module WithEthics
  # encodes finding of built in types.
  # I know that hard coding is wrong but I have to start somewhere.
  class TypeFinder
    attr_reader :finders
    KNOWN = %w(coc code_of_conduct deploy deployment_script gemfile license privacy privacy_policy readme test)
    
    def initialize(wanted_type, finder: nil)
      @finders = if KNOWN.include? wanted_type.to_s
        self.send(wanted_type).collect do |x|
          x += "\\.\\w+$" unless x.end_with?('$')
          Regexp.new x, Regexp::IGNORECASE
        end
    
        else
          raise ArgumentError.new "Unknown file type: #{ wanted_type }" if finder.nil?
          [finder].flatten # in case it comes in as an array
        end
    end
    
    private
    # Do these need a / in front of them (where the ^ used to be)
    # in order to exclude matching the wrong part of the path?
    
    # code of conduct
    def coc
      ['code_*of_*conduct', 'coc']
    end
    alias :code_of_conduct :coc
    
    # note: this may only work for the capistrano style deploy.rb
    # TODO: Look for other deployment methods.
    def deploy
      ['deploy']
    end
    alias :deployment_script :deploy
    
    def gemfile
      ['Gemfile$']
    end
    
    def license
      ['.*_*license']
    end

    def privacy
      ['privacy_*.*']
    end
    alias :privacy_policy :privacy
    
    def readme
      ['readme']
    end
    
    def test
      ['.*_test', '^.*_spec']
    end
  end
end