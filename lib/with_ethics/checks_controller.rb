require_relative 'promised_file'

module WithEthics
  # while this is called a controller, it is called that because of its function.
  # It should not be confused with a ruby on rails controller.
  # The controller, when given a promises object
  # actually configures and runs tests as required.
  # This is where the action happens.
  class ChecksController
    attr_reader :checks_run
    def initialize(pr)
      # The checks controller will run those things in the config
      # under checks.
      @promised = pr.config
      @checks_run = {}
    end
    
    def run_checks
      @promised["checks"].each do |check|
        @checks_run[check] =  self.send check.to_sym  # record completion status
      end
    end
    
    def promised_files
      @promised["promised_files"].each_key do |k|
        pr = PromisedFile.new filename: @promised["promised_files"][k]["filename"],
                              path: @promised["promised_files"][k]["path"]
        
        # log output!
        pr.can_be_used?
      end
      
      true  
    end
    
    def security_checks
      # do security test files exist?
      #   This is more complicated to check than files because it requires wildcards
      # is there a static analysis tool available?
      # What does the static analysis tool say?
      # how about permissions? Are they okay?
      # Are there ##security tags in the code?
      true
    end
    
    def version_control
      # Is the code checked in to github or subversion or mercurial? (screw any others)
      
      true
    end
    
    # untested
    def documentation
      # is there a readme file? # that's actually a file promise
      # is there a doc directory?
      # is the code well commented? ...
      # Are there TODOs in the code?
      # Are there a lot of # FIX 's in the code?
      false
    end
  end
end