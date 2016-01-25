require 'colorize'  # https://github.com/fazibear/colorize

module WithEthics
  class Reporter
    attr_reader :colorized, :output_to, :current_check_family, :progress
    Report = Struct.new(:message, :status)
    
    def initialize(**args)
      @colorized = true
      
      # # keep a running record of checks reported, indexed by family
      # with each family keeping an array of checks
      @current_check_family = "general"
      @progress = {
         @current_check_family => []
      }
      
      # it's possible to suppress all output
      @output_to = if args.has_key?(:output_to) 
        args[:output_to].include?('none') ? [] : args[:output_to]
      else
        ['console']
      end
    end
    
    def family=(name)
      @current_check_family = name
      @progress[name] ||= []
      
      # and print it
      # IMPORTANT TO DO: Keep this from printing when console is suppressed!
      # and also when tests run
      str = "Check family #{ @current_check_family }".colorize(:blue)
      output_to_path str
    end
        
    # TODO: Change output wording depending on test family.
    def report(target, status)      
      out_string = if status == true
        "\tFound #{ target }".colorize(:green)
        
      else
        "\tWhere is #{ target }?".colorize(:red)
      end
      
      output_to_path(out_string)
      store(out_string, status)
    end
    
    # actually handles the output of generated strings
    def output_to_path(str)
      if @output_to.include?('console')
        puts str
      end
    end
    
    # saves the check for later summary
    # IN: The message string and the (boolean) status of the check
    def store(str, st=nil)
      @progress[@current_check_family] << Report.new(str, st)
    end
  end
end