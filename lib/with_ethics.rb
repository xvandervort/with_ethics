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

module WithEthics
  
  def execute!(parms)
    @config = YamlReader.new( parms[:config_file] ).data
    @reporter = Reporter.instance
    @reporter.config # currently accepts default console output
    @pr = Promises.new @config
    @root = parms.has_key?(:root) ? parms[:root] : Dir.pwd
    controller = ChecksController.new @pr, reporter: @reporter, root: @root
    controller.run_checks
  end
end
