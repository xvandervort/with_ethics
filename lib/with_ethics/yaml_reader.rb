require 'yaml'

module WithEthics
  class YamlReader
    attr_reader :data
    
    def initialize(target = "promises.yml")
      @data = YAML.load_file target
    end
  end
end