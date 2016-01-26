module WithEthics
  # Starts with the configuration hash
  # and generates a list of promises
  # and the tests needed to check on them
  # NOTE: Because the original config comes in from a yaml file
  #       Keep all keys as strings. No symbols.
  class Promises
    attr_reader :config
    
    def initialize(args = {})
      @config = args
      
      # sanity checking and adding in defaults
      checks
      check_files
    end
    
    def get_checks(which)
      # assume which is a single test type
      # TODO: sanity check incoming
      @config[which].keys.collect{|x| @config[which][x]}
      
    end
    
    private
    
    # ensures there is a files key in config
    # and stocks it with defaults if they are not present
    def check_files
      @config["promised_files"] ||= {} 
      # do not yet have any defaults
      # but if there were some, here you would ensure they were included
      # unless explicitly removed
        
    end
    
    # ensures there are tests configured and
    # adds defaults unless explicitly excluded
    def checks
      @config["checks"] = [] unless @config.has_key?("checks")
      @config["checks"] << "promised_files" unless @config["checks"].include?("promised_files")
      @config["checks"] << "security_checks" unless @config["checks"].include?("security_checks")
      @config["checks"] << "version_control" unless @config["checks"].include?("version_control")
      
      # and non default ones
      %w(promised_tags).each do |key|
        @config["checks"] << key if @config.has_key?(key)
      end
    end
  end
end