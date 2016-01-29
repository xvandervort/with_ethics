module WithEthics
  # THIS CLASS IS NOW OBSOLETE
  
  # class looks for test folders and pulls a list of files
  # to be evaluated for quality/value/appropriateness.
  # Currently it just searches default ruby types.
  class Tfind
    attr_reader :target, :paths
    
    def initialize(typ: 'ruby', paths: ['test', 'spec'])
      @target = typ
      @paths = paths
    end
        
    def check_for_test_dir(l)
      # Now look in list for something that matches one of the choices
      found
      while found.nil? && candidate = l.shift
        found = candidate if @paths.include?(candidate.downcase)
      end
      
      found
    end
    
    def search(target = Dir.pwd)
      found = nil
      # look for anything matching the names in the paths variable
      @paths.each do |path|
        results = Dir.glob("#{ target }/**/#{ path }")
        
        # There can be only one!
        found = results.first unless results.empty?
        
        break unless found.nil?
      end

      # NOW I NEED TO FORMAT THE RESULTS
      out_list  = if found.nil? 
        # record no such animal
        
        []
      else
        # now get all the files out of there
        # To do: Match the correct ending for the entries
        Dir.entries(found).reject{|x| x =~ /^\.+$/}.
                           collect{|d| "#{ found }/#{ d }"}
      end
      
      # now return the test folder (if any) and the list of contents (if any)
      [found, out_list]
    end
  end
end