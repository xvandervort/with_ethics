require_relative "with_ethics/version"
require_relative "with_ethics/yaml_reader"
require_relative "with_ethics/promised_file"
require_relative "with_ethics/promises"
require_relative 'with_ethics/checks_controller'
require_relative 'with_ethics/reporter'
require_relative 'with_ethics/promised_tag'
require_relative 'with_ethics/file_info'
require_relative 'with_ethics/tfind'
require_relative 'with_ethics/type_finder'
require_relative 'with_ethics/file_system'
require_relative 'with_ethics/repo'
require_relative 'with_ethics/support/duration'

module WithEthics
  
  def execute!(parms)
    @reporter = Reporter.instance
    @config = YamlReader.new( parms[:config_file] ).data
    
    # set arguments for reporter, if any
    args = parms[:output_to].nil? ? {} : { output_to: parms[:output_to] }
    @reporter.config args
    
    @pr = Promises.new @config
    @root = parms.has_key?(:root) ? parms[:root] : Dir.pwd
    
    controller = ChecksController.new @pr, reporter: @reporter, root: @root
    controller.run_checks
  end
end
