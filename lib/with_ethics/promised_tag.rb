require_relative 'reporter'
require_relative 'file_info'

module WithEthics
  # class scans a file line by line to find
  # a tag of the form # Security or # TODO
  # and reports on how many have been found.
  class PromisedTag
    attr_reader :tag_list, :path, :recursive_search, :reporter, :found, :name
    
    def initialize(**args)
      keyname = args.has_key?(:tag) ? :tag : :tags 
      # if no tags given, it's an error
      @tag_list = (args[keyname].is_a?(Array) ? args[keyname] : [args[keyname]] ).compact
      
      @recursive_search = args[:recurse] || false
      @reporter = args[:reporter] || Reporter.new
      
      # TODO: If name is not given you might be able to pull it from the path
      @name = args[:name] || raise(ArgumentError)
      
      # fail without required items
      raise(ArgumentError) if @tag_list.empty?
      
      @ff = FileInfo.new name: @name, path: args[:path]
      @path = @ff.path
      
      # TODO: Make some better errors
      #raise(ArgumentError) unless @ff.can_be_used?
      
      @found = 0
    end
    
    # looks in the given file (only one for now) and counts instances of the tag
    def search
      # check that file can be used
      f = File.open @ff.fullpath, "r"
      r = /^\s*\#\s*#{ tag_list.first }/i
      f.each_line do |line|
        if line =~ r
          @found += 1
          
        end
      end
    end
  end
end