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

module WithEthics
  
  def execute!(parms)
    @config = YamlReader.new( parms[:config_file] ).data
    @pr = Promises.new @config
    controller = ChecksController.new @pr
    controller.run_checks
  end
end
