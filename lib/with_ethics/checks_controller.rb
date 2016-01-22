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
      true
    end
    
    def version_control
      true
    end
  end
end