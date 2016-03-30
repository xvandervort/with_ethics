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
  end
end