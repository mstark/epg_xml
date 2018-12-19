RSpec.describe EpgXml do
  it "has a version number" do
    expect(EpgXml::VERSION).not_to be nil
  end

  it "does something useful" do
    EpgXml::Generate.new([]).call
    #expect(false).to eq(true)
  end
end
