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

# <ProgramInformation programId="crid:///P38098112_3183256">
#   <BasicDescription>
#     <Title type="main" xml:lang="de">IMPACT Wrestling</Title>
#     <Title type="secondary" xml:lang="de">One Night Only: Night of the Dummies</Title>
#     <Synopsis xml:lang="de" length="short"></Synopsis>
#     <Synopsis xml:lang="de" length="long"></Synopsis>
#     <Genre type="main" href="urn:tva:metadata:cs:ContentCS:2005:3.2.13.6">
#       <Name xml:lang="de">Wrestling</Name>
#     </Genre>
#     <ParentalGuidance>
#       <mpeg7:MinimumAge xmlns:mpeg7="urn:mpeg:mpeg7:schema:2001">18</mpeg7:MinimumAge>
#       <mpeg7:Region xmlns:mpeg7="urn:mpeg:mpeg7:schema:2001">DE</mpeg7:Region>
#     </ParentalGuidance>
#   </BasicDescription>
#   <AVAttributes>
#     <AudioAttributes>
#       <Coding href="urn:mpeg:mpeg7:cs:AudioPresentationCS:2001:3">
#         <Name xml:lang="de">Stereo</Name>
#         <Definition xml:lang="de">Deutsch</Definition>
#       </Coding>
#       <NumOfChannels>1</NumOfChannels>
#     </AudioAttributes>
#   </AVAttributes>
# </ProgramInformation>
#
# <ScheduleEvent>
#   <Program crid="crid:///P38098112_3183256"/>
#   <InstanceDescription>
#     <Title xml:lang="de" type="epgevent">One Night Only: Night of the Dummies</Title>
#   </InstanceDescription>
#   <PublishedStartTime>2018-09-17T02:05:00Z</PublishedStartTime>
#   <PublishedEndTime>2018-09-17T04:50:00Z</PublishedEndTime>
#   <Live value="false"/>
# </ScheduleEvent>
#

module EpgXml
  attr_reader :events
  attr_accessor :doc

  class Generate
    def initialize(events)
      @events = events
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
              
            }
            xml.ProgramLocationTable {
              
            }
          }
        }
      end

      puts @doc.to_xml
    end

    private

    def schedule
      # <Schedule serviceIDRef="" start="2018-09-17T02:05:00Z" end="2018-10-10T22:00:00Z">
      # </Schedule>
    end

    def schedule_event
			# <ScheduleEvent>
			# 	<Program crid="crid:///P38098112_3183256"/>
			# 	<InstanceDescription>
			# 		<Title xml:lang="de" type="epgevent">One Night Only: Night of the Dummies</Title>
			# 	</InstanceDescription>
			# 	<PublishedStartTime>2018-09-17T02:05:00Z</PublishedStartTime>
			# 	<PublishedEndTime>2018-09-17T04:50:00Z</PublishedEndTime>
			# 	<Live value="false"/>
			# </ScheduleEvent>
    end

    def programm_information
  		# <ProgramInformation programId="crid:///P38098112_3183256">
  		# 	<BasicDescription>
  		# 		<Title type="main" xml:lang="de">IMPACT Wrestling</Title>
  		# 		<Title type="secondary" xml:lang="de">One Night Only: Night of the Dummies</Title>
  		# 		<Synopsis xml:lang="de" length="short"></Synopsis>
  		# 		<Synopsis xml:lang="de" length="long"></Synopsis>
  		# 		<Genre type="main" href="urn:tva:metadata:cs:ContentCS:2005:3.2.13.6">
  		# 			<Name xml:lang="de">Wrestling</Name>
  		# 		</Genre>
  		# 		<ParentalGuidance>
  		# 			<mpeg7:MinimumAge xmlns:mpeg7="urn:mpeg:mpeg7:schema:2001">18</mpeg7:MinimumAge>
  		# 			<mpeg7:Region xmlns:mpeg7="urn:mpeg:mpeg7:schema:2001">DE</mpeg7:Region>
  		# 		</ParentalGuidance>
  		# 	</BasicDescription>
  		# 	<AVAttributes>
  		# 		<AudioAttributes>
  		# 			<Coding href="urn:mpeg:mpeg7:cs:AudioPresentationCS:2001:3">
  		# 				<Name xml:lang="de">Stereo</Name>
  		# 				<Definition xml:lang="de">Deutsch</Definition>
  		# 			</Coding>
  		# 			<NumOfChannels>1</NumOfChannels>
  		# 		</AudioAttributes>
  		# 	</AVAttributes>
  		# </ProgramInformation>
    end
  end
end
