require "epg_xml/version"
require "nokogiri"
require "time"

# event = {
#   program_id: "uniq",
#   basic_description: {
#     title: {
#       main: "",
#       secondary: ""
#     },
#     synopsis: {
#       short: "",
#       long: ""
#     },
#     genre: {
#       name: ""
#     },
#     parental_guidance: {
#       minimum_age: "int",
#       region: "iso_code"
#     }
#   },
#   av_attributes: {
#     audio_attribute: {
#       coding: {
#         name: "",
#         definition: ""
#       },
#       number_of_channels: "int",
#     }
#   },
#   schedule: {
#     start_time: "iso8601",
#     end_time: "iso8601",
#     live: "true|false"
#   }
# }

module EpgXml
  class Generate
    attr_reader :events, :xml_lang

    def initialize(events, xml_lang = "de")
      @events = events
      @xml_lang = xml_lang
    end


    def call
      @doc = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.TVAMain(
          "xmlns" => "urn:tva:metadata:2002",
          "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
          "xml:lang" => "en",
          "publisher" => "",
          "publicationTime" => Time.now.utc.iso8601
        ) {
          xml.ProgramDescription {
            xml.ProgramInformationTable {
              program_information(xml)
            }
            xml.ProgramLocationTable {
              schedule(xml)
            }
          }
        }
      end

      @doc.to_xml
    end

    private

    def schedule_start
      events_by_start_time.first[:schedule][:start_time]
    end

    def schedule_end
      events_by_start_time.last[:schedule][:end_time]
    end

    def events_by_start_time
      @events_by_start_time ||= events.sort_by { |a| a[:schedule][:start_time] }
    end

    def schedule(xml)
      xml.Schedule("serviceIDRef" => "", "start" => schedule_start, "end" => schedule_end) {
        events.each do |event|
          xml.ScheduleEvent {
            xml.Program("crid" => event[:program_id])
            xml.InstanceDescription {
              xml.Title("xml:lang" => xml_lang, "type" => "epgevent") {
                xml.text event[:basic_description][:title][:secondary]
              }
            }
            xml.PublishedStartTime event[:schedule][:start_time]
            xml.PublishedEndTime event[:schedule][:end_time]
            xml.Live(value: event[:schedule][:live])
          }
        end
      }
    end

    def program_information(xml)
      events.each do |event|
        xml.ProgramInformation("programId" => event[:program_id]) {
          xml.BasicDescription {
            xml.Title("type" => "main", "xml:lang" => xml_lang) {
              xml.text event[:basic_description][:title][:main]
            }
            xml.Title("type" => "secondary", "xml:lang" => xml_lang) {
              xml.text event[:basic_description][:title][:secondary]
            }
            xml.Synopsis("length" => "short", "xml:lang" => xml_lang) {
              xml.text event[:basic_description][:synopsis][:short]
            }
            xml.Synopsis("length" => "long", "xml:lang" => xml_lang) {
              xml.text event[:basic_description][:synopsis][:long]
            }
            xml.Genre("type" => "main") {
              xml.Name("xml:lang" => xml_lang) {
                xml.text event[:basic_description][:genre][:name]
              }
            }
            parental_guidance(xml, event)
          }
          av_attributes(xml, event)
        }
      end
    end

    def parental_guidance(xml, event)
      xml.ParentalGuidance {
        xml["mpeg7"].MinimumAge("xmlns:mpeg7" => "urn:mpeg:mpeg7:schema:2001") {
          xml.text event[:basic_description][:parental_guidance][:minimum_age]
        }
        xml["mpeg7"].Region("xmlns:mpeg7" => "urn:mpeg:mpeg7:schema:2001") {
          xml.text event[:basic_description][:parental_guidance][:region]
        }
      }
    end

    def av_attributes(xml, event)
      xml.AVAttributes {
        xml.AudioAttributes {
          xml.Coding {
            xml.Name("xml:lang" => xml_lang) {
              xml.text event[:av_attributes][:audio_attribute][:coding][:name]
            }
            xml.Definition("xml:lang" => xml_lang) {
              xml.text event[:av_attributes][:audio_attribute][:coding][:definition]
            }
          }
          xml.NumOfChannels event[:av_attributes][:audio_attribute][:number_of_channels]
        }
      }
    end
  end
end
