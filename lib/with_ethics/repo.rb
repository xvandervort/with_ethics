require 'active_support/core_ext/string'

module WithEthics
  # finds a repository of a known type
  # and does some basic quality checks. 
  class Repo
    attr_reader :type, :reporter, :root
    KNOWN_TYPES = %w(git svn hg)
    
    def initialize(type: nil, reporter: Reporter.instance, root: Dir.pwd)
      @type = type # later, if none given, it will be found if possible
      @reporter = reporter
      @root = root
    end
    
    # looks in root for the designated repo type
    def find
      found = false
      find_list = @type.nil? ? KNOWN_TYPES : [@type]
      find_list.each do |typ|
        if find_repo(typ)
          @type = typ
          found = true
          report_found
          break
        end
      end
      
      # now react to whether nothing was found
      @reporter.report_message("\tNo version control found.", false) unless found
      found
    end
    
    private
    
    def find_repo(typ)
      repo_path = "#{ @root }/.#{ typ }"
      !!(File.exists?(repo_path) && File.directory?(repo_path))
    end
    
    def report_found
      @reporter.report("#{ @type } repository", true)
    end
  end
end