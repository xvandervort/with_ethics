require 'spec_helper'

module WithEthics
  describe ChecksController do
    
    before do
      # generic config hash
      @config = {
        "promised_files" => {
          "code_of_conduct" => {
            "filename" => "CODE_OF_CONDUCT.md",
            "path" => "root"
          }
        },
        
        "checks" => ['promised_files']
        
      }
      
      @pr = Promises.new @config
      @cc = ChecksController.new @pr
    end
    
    it "initializes with yml output hash" do
      expect(@cc).to_not be_nil
      expect(@cc).to be_kind_of(ChecksController)
    end
    
    # WARNING: This test will be brittle until we include some mocking
    # or a feature to suppress output
    it "runs checks" do
      @cc.run_checks
      expect(@cc.checks_run.keys).to include("promised_files")
      
      # note that the following checks were added because they are defaults
      expect(@cc.checks_run.keys).to include("security_checks")
      expect(@cc.checks_run.keys).to include("version_control")
    end
    
    it "actually runs file checks" do
      expect(@cc.promised_files).to be(true)
    end
    
  end
end