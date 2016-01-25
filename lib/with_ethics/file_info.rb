module WithEthics
  # Mostly just arranges that paths are usable.
  # probably should move stats into here too
  class FileInfo
    attr_reader :name, :path, :fullpath, :stats
    
    def initialize(**args)
      @name = args[:name]
      @path = fix_root(args[:path]) || Dir.pwd
      sep = if @path =~ /.*\/$/
        ""
        
      else
        '/'
      end
      @fullpath = "#{ @path }#{ sep }#{ @name }"
      @stats = {}
    end
    
    def get_stats
      file_stats if @stats.keys.empty?
      @stats
    end
    
    # checks that file exists
    def check_for_file
      File.exist? @fullpath  
    end
  
    # pulls info about the file
    def file_stats
      if check_for_file == true
        @stats[:exists] = true
        fs = File.stat @fullpath
        
        @stats[:size] = fs.size
        @stats[:readable] = fs.readable? 
        @stats[:last_modified] = fs.mtime 
        @stats[:is_file] = fs.file? 
        @stats[:is_directory] = fs.directory? 
        
      else
        
        @stats[:exists] = false
      end
    end
    
    def can_be_used?
      file_stats if @stats.empty?
      !!(@stats[:exists] && @stats[:size] > 0 && @stats[:is_file] == true && @stats[:readable] == true)
    end
    
    def fix_root(pth)
      if pth.nil? || pth.empty?
        nil
      else
        pth.gsub /@root/i, Dir.pwd
      end
    end
  end
end