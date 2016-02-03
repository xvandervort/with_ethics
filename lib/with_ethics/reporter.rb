require 'colorize'  # https://github.com/fazibear/colorize
require 'singleton'

module WithEthics
  class Reporter
    include Singleton
    attr_reader :output_to, :current_check_family, :progress
    Report = Struct.new(:message, :status)
    
    # must be called at least once.
    def config(**args)
      # # keep a running record of checks reported, indexed by family
      # with each family keeping an array of checks
      @current_check_family ||= "general"
      @progress ||= {
         @current_check_family => []
      }
      
      # it's possible to suppress all output
      # This can be changed by calling config again
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
        "\tFound #{ target }"
        
      else
        "\tWhere is #{ target }?"
      end
      
      report_message(out_string, status)
    end
    
    def report_problem(message) # assumed to be false
      report_message("\t\tFound a problem with #{ message }!", false)
    end
    
    # actually handles the output of generated strings
    def output_to_path(str)
      if @output_to.include?('console')
        puts str
      end
    end
    
    # no interpolation except color. Passes message right through
    def report_message(message, state)
      color = state == true ? :green : :red
      str = message.colorize(color)
      output_to_path(str)
      store(str, state)
    end
    
    # saves the check for later summary
    # IN: The message string and the (boolean) status of the check
    def store(str, st=nil)
      @progress[@current_check_family] << Report.new(str, st)
    end
  end
end