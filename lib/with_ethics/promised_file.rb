# This class, given a file name and specs
# finds it and reports whether it exists, has non zero length,
# and how knows what other wonderful things?
module WithEthics
  class PromisedFile
    attr_reader :filename, :path, :stats
    
    
    def initialize(**args)
      @filename = args[:filename] # || throw an error!
      @path = fix_root(args[:path]) # || root path
      @full_path = "#{ @path }/#{ @filename }"
      @stats = {}
    end
    
    # checks that file exists
    def check_for_file
      File.exist? @full_path  
    end
  
    # pulls info about the file
    def file_stats
      if check_for_file == true
        @stats[:exists] = true
        fs = File.stat @full_path
        
        @stats[:size] = fs.size
        @stats[:readable] = fs.readable? 
        @stats[:last_modified] = fs.mtime 
        @stats[:is_file] = fs.file? 
        @stats[:is_directory] = fs.directory? 
        
      else
        @stats[:exists] = false
      end
    end
    
    private
    
    def fix_root(pth)
      if pth == "root" || pth.nil?
        Dir.pwd
      else
        pth
      end
    end
  end
end