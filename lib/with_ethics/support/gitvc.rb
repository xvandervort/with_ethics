require 'git'

module WithEthics
  # gather data about git repository
  # Using read-only methods!
  class Gitvc
    attr_reader :path, :git, :status, :last_commit, :changed, :untracked
    
    def initialize(source_path)
      @path = source_path
      @git = Git.open(@path)
      @status = []
    end
    
    # asks the git log for basic info
    # TODO: Check to see how long it has been sinve the last commit and comment
    #       That would mean a repo is either recent, 
    def log_info
      begin
        # produces an error if there is nothing there
        @log = @git.log
        @last_commit = @log.first.date
        # TODO: Make status more meaningful. Possibly express how up to date the repo is
        @status << "initialized"
        
      rescue
        @log = []
        @status << "empty"
        @last_commit = nil
      end
    end
    
    # retrieves a status object and learns important info from it
    # TODO: Ensure checking branch master (or designated root branch)
    def status_info
      @untracked = 0
      @changed = 0
      
      s = @git.status
      # check for changed files
      unless s.changed.empty?
        @status << "changes"
        
        # The count of modified, uncommitted files
        @changed = s.changed.keys.size
      end
      
      unless s.added.empty?
        @status << "untracked"
        @untracked = s.added.keys.size
      end
      
      if @untracked + @changed == 0
        @status << "up to date"
      end
      
    end
    
    def results(**args)
      out = { summary: "Repository is in #{ status_summary } condition." }
      if args.has_key?(:verbose) && args[:verbose] == true
        d = Duration.new
        # add in the age and state of files
        out[:age] = "It has been #{ d.since(@last_commit) } since the last commit." unless @last_commit.nil?
        out[:changes] = "There are uncommited changes." unless @changed == 0
        out[:missing] = "There are untracked files." unless @untracked == 0
      end
      
      out
    end
    
    private
    
    # TODO: Take time since last commit into account?
    def status_summary
      if @changed.size == 0 && @untracked.size == 0
        "good"
        
      elsif @changed.size > 0 && @untracked.size == 0
        "questionable"
        
      else
        # both untracked and changed files in the repo
        "poor"
      end
    end
  end
end