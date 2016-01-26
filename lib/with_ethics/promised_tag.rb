require_relative 'reporter'
require_relative 'file_info'

module WithEthics
  # class scans a file line by line to find
  # a tag of the form # Security or # TODO
  # and reports on how many have been found.
  class PromisedTag
    attr_reader :tag, :path, :recursive_search, :reporter, :found, :name
    
    def initialize(**args)
      # if no tags given, it's an error
      @tag = args[:tag] || raise(ArgumentError)
      
      @recursive_search = args[:recurse] || false # NOT YET IMPLEMENTED
      @reporter = args[:reporter] || Reporter.new
      
      # TODO: If name is not given you might be able to pull it from the path
      @name = args[:name] || raise(ArgumentError)
      
      @ff = FileInfo.new name: @name, path: args[:path]
      @path = @ff.path
      
      # TODO: Make some better errors
      #raise(ArgumentError) unless @ff.can_be_used?
      
      @found = 0
    end
    
    # looks for tags in the given file(s) and counts them
    def search
      # If there's only one in the list, there will still be a list
      @ff.each_file do |fil|
        
        # TODO: check for unreadable files and record them as such
        f = File.open fil.fullpath, "r"
        r = /^\s*\#\s*#{ @tag }/i
        f.each_line do |line|
          if line =~ r
            @found += 1
            #@repo
          end
        end
      end
      
      @reporter.report "'#{ @tag }' tag #{ @found } time(s)", (@found > 0)
    end
  end
end