module WithEthics
  # Mostly just arranges that paths are usable.
  # probably should move stats into here too
  class FileInfo
    attr_reader :name, :path, :fullpath, :stats, :paths
    
    def initialize(**args)
      @path = fix_root(args[:path]) || Dir.pwd
      
      if args[:name] =~ /\*/
        # with wildcard gets you a different result
        @paths = Dir["#{ @path }/#{ args[:name] }"]
        
        # Note that name and fullpath are empty.
        # If there's a wildcard, use the iterator to get at things.
      else       
        @name = args[:name]
        @fullpath = "#{ @path }#{ path_separator_if_needed }#{ @name }"
        
        # protection against accidentally using the iterator
        @paths = [@fullpath]
      end
      
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
        pth.gsub(/@root/i, Dir.pwd)
      end
    end
    
    def path_separator_if_needed
      if @path =~ /.*\/$/
        ""
        
      else
        '/'
      end
    end
    
    # iterates over the path list, creating a file_info object for each
    # Yes, it's a factory for itself. That's a legit pattern!
    def each_path
      @paths.each do |pth|
        yield FileInfo.new name: File.basename(pth), path: File.dirname(pth)
      end
    end
    # Because I can never remember which one I used ...
    alias :each_file :each_path
  end
end