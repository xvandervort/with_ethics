require_relative 'file_info'

# This class, given a file name and specs
# finds it and reports whether it exists, has non zero length,
# and how knows what other wonderful things?
module WithEthics
  class PromisedFile
    attr_reader :filename, :path, :stats
    
    def initialize(**args)
      @filename = args[:filename] # || throw an error!
      @ff = FileInfo.new name: @filename, path: args[:path]
      @path = @ff.path
      @full_path = @ff.fullpath
      @stats = @ff.file_stats
    end
    
    # checks that file exists
    # TODO: use active support's delegate method ?
    def check_for_file
      @ff.check_for_file  
    end
  
    # pulls info about the file
    def file_stats
      @stats = @ff.get_stats
    end
    
    def can_be_used?
      @ff.can_be_used?
    end
  end
end