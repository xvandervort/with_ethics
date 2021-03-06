require 'spec_helper'

module WithEthics
  describe Promises do
    before do
      # generic config hash
      @config = {
        "promised_files" => {
          "code_of_conduct" => {
            "filename" => "CODE_OF_CONDUCT.md"
          },
        
          "privacy_policy" => {
              "filename" => "privacy.doc",
              "path" => "root/public" # does this get interpreted correctly by the file finder?
          },
              
          "deployment_script" => {
              "filename" => "deploy.rb"
          },
          
          "readme" => {
            "filename" => "README.md"
          }
        },
        
        "promised_tags" => {
          "security" => {
            "filename" => "*.rb",
            "path" => "@root/spec/files"
          }
        },
        
        "tests" => {
          "type" => "ruby"
        },
        
        "version_control" => {
          "type" => "git"
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
    
    it "should list promised tags check when told" do
      pr = Promises.new @config
      expect(pr.config["checks"]).to include("promised_tags")
    end
    
    it "should look for tests" do
      pr = Promises.new @config
      expect(pr.config["checks"]).to include("tests")
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
    
    it "should know given type of version control" do
      pr = Promises.new @config
      expect(pr.config["version_control"]["type"]).to eq("git")
    end
  end
  
  describe "global settings config" do
    it "should set root from config file" do
      config = {
        "globals" => {
          "root" => "/home/username/code/my_project"
        }
      }
      
      pr = Promises.new config
      expect(pr.config["globals"]["root"]).to eq(config["globals"]["root"])
    end
  end
end