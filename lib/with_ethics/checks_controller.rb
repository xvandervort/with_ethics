require_relative 'file_system'

module WithEthics
  # while this is called a controller, it is called that because of its function.
  # It should not be confused with a ruby on rails controller.
  # The controller, when given a promises object
  # actually configures and runs tests as required.
  # This is where the action happens.
  class ChecksController
    attr_reader :checks_run, :reporter, :root
    
    # In: a promises object and a reporter
    # Reporter is required in order to preserve config
    def initialize(pr, reporter:, root: nil)
      # The checks controller will run those things in the config
      # under checks.
      @promised = pr.config
      @checks_run = {}
      @reporter = reporter
      @root = find_root(root)
    end
    
    def run_checks
      @promised["checks"].each do |check|
        # remember the checks now being run
        @reporter.family = check
        
        @checks_run[check] =  self.send check.to_sym  # record completion status
      end
    end
    
    def promised_files
      @sys = FileSystem.new root: @root, reporter: @reporter
      @promised["promised_files"].each_key do |k|
        found = if @promised['promised_files'][k].nil?
          # means we are looking for a default type.
          @sys.find k
          
        elsif @promised['promised_files'][k].has_key?("filename")
          # This is an explicitly designated file and may or may not have a path
          ["#{ @promised["promised_files"][k]["path"] }/#{ @promised["promised_files"][k]["filename"] }"]
        
        else
          #  Test looking for a custom type!
        end
        
        result = false
        # TODO: report results (useable or not) for every answer
        found.each do |ex|
          pr = PromisedFile.new filename: File.basename(ex), path: File.path(ex)
          result = pr.can_be_used?
        end

        result
      end
      
      # TODO: replace with a begin/rescue block that returns false if rescued, true otherwise
      true  
    end
    
    def promised_tags
      @promised["promised_tags"].each_key do |k|
        
        pr = PromisedTag.new  tag: k,
                              name: @promised["promised_tags"][k]["filename"],
                              path: @promised["promised_tags"][k]["path"],
                              reporter: @reporter
        pr.search
        
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
    
    def tests
      
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
        
    private
    
    # searches through given info for root
    # or just makes it up
    def find_root(r)
      r || (@promised.has_key?("globals") && @promised["globals"].has_key?("root") ?
            @promised["globals"]["root"] : Dir.pwd)
    end
  end
end