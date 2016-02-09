require 'yaml'

module WithEthics
  class YamlReader
    attr_reader :data
    
    def initialize(target = "promises.yml")
      # TODO: add sanity checking on keys/values
      # For example, a path should not have the value of true.
      @data = YAML.load_file target
    end
  end
end