require 'active_support/core_ext/string'

module WithEthics
  # finds a repository of a known type
  # and does some basic quality checks. 
  class Repo
    attr_reader :type, :reporter, :root
    
    def initialize(type: nil, reporter: Reporter.instance, root: Dir.pwd)
      @type = type # later, if none given, it will be found if possible
      @reporter = reporter
      @root = root
    end
    
    # looks in root for the designated repo type
    def find
      # TODO: break out type "any" and concatenate possibilities
      repo_path = "#{ @root }/.#{ @type }"

      if File.exists?(repo_path) && File.directory?(repo_path)
        @reporter.report("#{ @type } repository", true)
        true
      else
        @reporter.report_message("\tSpecified version control type #{ @type.titlecase } not found.", false)
        false
      end
    end
  end
end