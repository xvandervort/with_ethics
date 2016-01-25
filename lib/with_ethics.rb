require "with_ethics/version"
require "with_ethics/yaml_reader"
require "with_ethics/promised_file"
require "with_ethics/promises"
require 'with_ethics/checks_controller'
require 'with_ethics/reporter'
require 'with_ethics/promised_tag'
require 'with_ethics/file_info'

module WithEthics
  
  def execute!(parms)
    @config = YamlReader.new( parms[:config_file] ).data
    @pr = Promises.new @config
    controller = ChecksController.new @pr
    controller.run_checks
  end
end
