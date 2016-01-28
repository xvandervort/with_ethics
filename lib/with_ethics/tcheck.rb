require_relative 'tfind'
require_relative 'reporter'
require_relative 'file_info'

module WithEthics
  class Tcheck
    attr_reader :path, :reporter
    
    def initialize(path: Dir.pwd, reporter: Reporter.new)
      @path = path
      @reporter = reporter
    end
    
    def search
      @t = Tfind.new 
      top, list = @t.search @path
      if top.nil?
        #failure!
        @reporter.report "the test directory", false 
      else
        @reporter.report "test directory at #{ top }", true
        
        # and now start vetting the test files!
        list.each do |fil|
          f = FileInfo.new path: File.dirname(fil), name: File.basename(fil)
          
          # TODO: add checks for modification time and content
          if f.can_be_used? && f.stats[:size] > 120
            @reporter.report "test file #{ fil }; seems okay", true
            
          else
            @reporter.report_problem "test file #{ fil }"
          end
        end
      end
    end
  end
end