require 'spec_helper'
require 'yaml'

module WithEthics
  describe YamlReader do
    before do
      allow(YAML).to receive(:load_file).with("promises.yml").and_return(fake_yaml)
    end
    
    # just read in the yaml file
    # TODO: add some sanity checks to the keys.
    it "should read default" do
      y = YamlReader.new
      expect(y.data).to be_kind_of(Hash)
      
    end
    
    
    def fake_yaml
      {
        code_of_conduct: {
          filename: "codeofconduct.txt",
          path: "@root"
        }
      }
    end
  end
end