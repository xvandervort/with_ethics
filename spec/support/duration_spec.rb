require 'spec_helper'
require 'active_support/core_ext/date'
require "active_support/core_ext/numeric/time"

module WithEthics
  describe Duration do
    describe "general" do
      it "should initialize current time" do
        d = Duration.new
        expect(d.current).to be_kind_of DateTime
      end
    end
    
    describe "one date" do
      before do
        @d = Duration.new
      end
      
      it "should know days ago" do
        t = 2.days.ago
        expect(@d.since(t)).to eq("2 day(s) ago")
      end
      
      it "should know 2 hours ago" do
        t = 2.hours.ago
        expect(@d.since(t)).to eq("2 hours ago")
      end
    
      it "should know ten minutes ago" do
        t = 10.minutes.ago
        expect(@d.since(t)).to eq("10 minutes ago")
      end
      
      it "should know mixed increments ago" do
        t = 2.days.ago - 3.hours - 5.minutes
        expect(@d.since(t)).to eq("2 day(s) 3 hours 5 minutes ago")
      end
      
      it "should know when time is in the future" do
        t = DateTime.now + 20.minutes
        expect(@d.since(t)).to eq("ERROR. Time given is in the future!")
      end
      
      it "should know when time is current" do
        t = DateTime.now
        expect(@d.since(t)).to eq("now")
      end
    end
  end
end