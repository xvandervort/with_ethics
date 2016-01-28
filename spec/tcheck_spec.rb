require 'spec_helper'

module WithEthics
  describe Tcheck do
    describe "init" do
      it "should use default path" do
        t = Tcheck.new
        expect(t.path).to eq(Dir.pwd)
      end
      
      it "should use a default reporter" do
        t = Tcheck.new
        expect(t.reporter).to be_kind_of Reporter
      end
    end
    
    describe "search" do
      before do
        @t = Tcheck.new
        @cur = Dir.pwd
      end
      
      it "should find the obvious" do
        allow(Dir).to receive(:glob).with("#{ @cur }/**/test").and_return(["#{ @cur }/test"])
        allow(Dir).to receive(:entries).and_return(['.', '..', "some_test.rb"])
  
        pref = "#{ @cur }/test"
        
        # Note that the output actually comes from the reporter
        # and includes both the find and the vetting of the file - which failed
        expect{ @t.search }.to output( "\e[0;32;49m\tFound test directory at #{ pref }\e[0m\n\e[0;31;49m\t\tFound a problem with test file #{ pref }/some_test.rb!\e[0m\n" ).to_stdout
      end
      
      it "should report not finding" do
        allow(Dir).to receive(:glob).and_return([], [])
  
        # Note that the output actually comes from the reporter
        expect{ @t.search }.to output( "\e[0;31;49m\tWhere is the test directory?\e[0m\n" ).to_stdout        
      end
    end
  end
end