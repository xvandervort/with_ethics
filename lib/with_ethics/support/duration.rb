require 'active_support/core_ext/date'

module WithEthics
  # checks how long between 2 events
  # and describes it with an appropriate string.
  # Also may say whether duration has been too long (or too short) [not yet implemented]
  class Duration
    attr_reader :current
    
    def initialize
      @current = DateTime.now
    end
    
    # in: A date or datetime object
    # out: how long between then and now
    def since(prev)
      prev = prev.to_datetime unless prev.is_a?(DateTime)
      b = @current - prev  # how many days in between
      if b.round(4) < 0
        "ERROR. Time given is in the future!"
      
      else
        in_words(b)
        
      end
    end
    
    
    private
    
    # changes time into the nearest day/hour/minute
    def in_words(t)
      # to get the number of minutes subtract out days
      # Then calculate hours and subtract those out to get minutes.
      s = []
      days = t.round(4).to_i
      s << "#{ days } day(s)" unless days == 0
      
      remainder = t - days
      minutes = remainder * 1440.0 # number of minutes in a day
      hours = (minutes / 60.0).round.to_i
      s << "#{ hours } hours" unless hours == 0
      
      # round to 2 decimal places and call it
      minutes = (minutes - hours * 60).round
      s << "#{ minutes } minutes" unless minutes == 0
      
      if s.empty?
        s << "now"
      else
        s << "ago"
      end
      
      s.join(" ")
    end
  end
end