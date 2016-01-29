require_relative 'file_info'
require_relative 'type_finder'

# This class, given a file name and specs
# finds it and reports whether it exists, has non zero length,
# and who knows what other wonderful things?
module WithEthics
  class FileSystem
    attr_reader :root, :reporter
    
    def initialize(root:, reporter: Reporter.new)
      @root = root
      @reporter = reporter
    end
    
    def find(target, pattern = nil)
      @files ||= Dir.glob("#{ @root }/**/*")
      
      # TODO: catch unhandled errors
      pattern = TypeFinder.new target.to_sym, finder: pattern
      
      # TODO: remove folders from results
      output = []
      pattern.finders.each do |f|
        output.concat @files.grep(f)
      end
      
      report(output, target)
      output
    end
    
    # TODO: Add search for folders and for files with specific types of content.
    
    private
    
    def report(out, t)
      if out.empty?
        @reporter.report_problem "file type #{ t }"
        
      else
        out.each do |found|
          @reporter.report found, true
        end
      end
    end
  end
end