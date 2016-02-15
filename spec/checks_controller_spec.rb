require 'spec_helper'

module WithEthics
  describe ChecksController do
    
    before do
      # generic config hash
      @config = {
        "promised_files" => {
          "code_of_conduct" => {
            "filename" => "CODE_OF_CONDUCT.md",
            "path" => "@root"
          },
          
          "readme" => nil
        }, 
        "checks" => ['promised_files']
        
        }
      @reporter = Reporter.instance
      @reporter.config output_to: []
      @pr = Promises.new @config
      @cc = ChecksController.new @pr, reporter: @reporter
    end

    describe "init" do    
      it "initializes with yml output hash" do
        expect(@cc).to_not be_nil
        expect(@cc).to be_kind_of(ChecksController)
      end
      
      # The controller needs to be configured with command line info
      # so best to pass it in after creation rather than try to initialize it internally
      it "should accept a reporter on init" do
        expect(@cc.reporter).to be_kind_of(Reporter)
      end

      it "should accept root param" do
        rp = '/some/path'
        cc2 = ChecksController.new @pr, reporter: @reporter, root: rp
        expect(cc2.root).to eq(rp)
      end
    end
    
    describe "checks" do
    
      # WARNING: This test will be brittle until we include some mocking
      # or a feature to suppress output
      it "runs checks" do
        @reporter.config output_to: []
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
        @reporter.config output_to: []
        cc2 = ChecksController.new pr, reporter: @reporter
        
        cc2.run_checks
        expect(cc2.checks_run.keys).to include("promised_files")
  
        expect(cc2.promised_tags).to be(true)
      end
      
      it "actually runs test check" do
        cur = Dir.pwd
        allow(Dir).to receive(:glob).with("#{ cur }/**/*").and_return(["#{ cur }/test"])
        allow(Dir).to receive(:entries).and_return(['.', '..', "some_test.rb"])
        config = @config.merge "tests" => {
              "type" => "ruby"
            }
        pr = Promises.new config
        r = Reporter.instance
        r.config output_to: []
        cc2 = ChecksController.new pr, reporter: r
        cc2.run_checks
        expect(cc2.checks_run.keys).to include("tests")      
      end
      
      it "actually runs file checks" do
        expect(@cc.promised_files).to be(true)
      end
      
      it "actually runs vc checks" do
        path = "#{ Dir.pwd }/.git"
        allow(File).to receive(:exists?).with(path).and_return(true)
        config = @config.merge "version_control" => {
              "type" => "git"
            }
        pr = Promises.new config
        r = Reporter.instance
        r.config output_to: []
        cc2 = ChecksController.new pr, reporter: r
        cc2.run_checks
        expect(cc2.checks_run.keys).to include("version_control")
      end
      
      it "should report one check" do
        @cc.run_checks
        expect(@cc.reporter.progress.keys).to include(@config["checks"].first)
        
        expect(@cc.reporter.progress[@config["checks"].first].first.message).to match(/README.md/)
      end
    end
  end
  
  describe "globals" do
    it "should set root from promises object"  do
      config = {
        "globals" => {
          "root" => "/home/username/code/my_project"
        }
      }
      
      reporter = Reporter.instance
      reporter.config output_to: []
      pr = Promises.new config
      cc = ChecksController.new pr, reporter: reporter
      expect(cc.root).to eq(config["globals"]["root"])
    end
  end
end