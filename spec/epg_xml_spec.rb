require "securerandom"

RSpec.describe EpgXml do

  let(:event) {
    {
      program_id: SecureRandom.hex(4),
      basic_description: {
        title: {
          main: "IMPACT Wrestling",
          secondary: "One Night Only: Night of the Dummies"
        },
        synopsis: {
          short: "",
          long: ""
        },
        genre: {
          name: "Wrestling"
        },
        parental_guidance: {
          minimum_age: 18,
          region: "DE"
        }
      },
      av_attributes: {
        audio_attribute: {
          coding: {
            name: "Stereo",
            definition: "Deutsch"
          },
          number_of_channels: 1,
        }
      },
      schedule: {
        start_time: Time.new(2018, 12, 19, 12, 0, 0).utc.iso8601,
        end_time: Time.new(2018, 12, 19, 18, 0, 0).utc.iso8601,
        live: false
      }
    }
  }

  it "has a version number" do
    expect(EpgXml::VERSION).not_to be nil
  end

  it "does something useful" do
    xml = EpgXml::Generate.new([event, event]).call
    expect(xml).to include("IMPACT Wrestling")
    expect(xml).to include("One Night Only: Night of the Dummies")
  end
end
