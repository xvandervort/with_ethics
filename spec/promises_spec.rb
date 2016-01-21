require 'spec_helper'

module WithEthics
  describe Promises do
    before do
      # generic config hash
      @config = {
        "promised_files" => {
          "code_of_conduct" => {
            "filename" => "CODE_OF_CONDUCT.md",
            "path" => "root"
          },
        
          "privacy_policy" => {
              "filename" => "privacy.doc",
              "path" => "root/public" # does this get interpreted correctly by the file finder?
          },
              
          "deployment_script" => {
              "filename" => "deploy.rb",
              "path"  => "root"
          },
          
          "readme" => {
            "filename" => "README.md",
            "path" => "root"
          }
        }
      }
    end
    
    it "should use default config if none given" do
      pr = Promises.new
      expect(pr.config).to be_kind_of Hash
      expect(pr.config.keys).to include("promised_files")
      expect(pr.config.keys).to include("checks")
      # I can't think of anything else yet.
    end
    
    it "should list files test by default" do
      pr = Promises.new
    
      # tests is an array of test names
      expect(pr.config["checks"]).to include("promised_files")
    end
    
    it "should list security_tests test by default" do
      pr = Promises.new
    
      # tests is an array of test names
      expect(pr.config["checks"]).to include("security_checks")
    end
    
    it "should list version control test by default" do
      pr = Promises.new
    
      # tests is an array of test names
      expect(pr.config["checks"]).to include("version_control")
    end
    
    # Will not yet configure basic files to check.
    # most of what I have above is in supporting documentation.
    # Is that a separate test?
    # do I separate unit and integration tests?
    
    it "should return a list of file tests" do
      pr = Promises.new @config
      l = pr.get_checks("promised_files")
      expect(l).to be_kind_of(Array)
      expect(l.size).to eq(@config["promised_files"].keys.size)
      
      # LOOKS like config format is verkakt
    end
  end
end