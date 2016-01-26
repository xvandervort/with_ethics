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
      @reporter = Reporter.new output_to: []
      @pr = Promises.new @config
      @cc = ChecksController.new @pr, @reporter
    end
    
    it "initializes with yml output hash" do
      expect(@cc).to_not be_nil
      expect(@cc).to be_kind_of(ChecksController)
    end
    
    # WARNING: This test will be brittle until we include some mocking
    # or a feature to suppress output
    it "runs checks" do
      @cc.run_checks
      
      # note that the following checks were added because they are defaults
      expect(@cc.checks_run.keys).to include("security_checks")
      expect(@cc.checks_run.keys).to include("version_control")
    end
    
    it "actually runs tag checks" do
      config = @config.merge "promised_tags" => {
            "security" => {
              "filename" => "*.rb",
              "path" => "@root/spec/files"
            }
          }
        
      pr = Promises.new config
      cc2 = ChecksController.new pr, Reporter.new(output_to: [])
      cc2.run_checks
      expect(cc2.checks_run.keys).to include("promised_files")

      expect(cc2.promised_tags).to be(true)
    end
    
    it "actually runs file checks" do
      expect(@cc.promised_files).to be(true)
    end
    
    # The controller needs to be configured with command line info
    # so best to pass it in after creation rather than try to initialize it internally
    it "should accept a controller on init" do
      expect(@cc.reporter).to be_kind_of(Reporter)
    end
    
    it "should report one check" do
      @cc.run_checks
      expect(@cc.reporter.progress.keys).to include(@config["checks"].first)
      expect(@cc.reporter.progress[@config["checks"].first].first.message).to match(/CODE_OF_CONDUCT.md/)
    end
  end
end