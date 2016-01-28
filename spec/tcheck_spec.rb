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
        
        d = instance_double("FileInfo")
        allow(d).to receive(:stats).with(:is_directory?).and_return(false)
        allow(d).to receive(:stats).with(:size).and_return(2014)
        allow(d).to receive(:stats).with(:empty?).and_return(false)
  
        pref = "#{ @cur }/test"
        
        # Note that the output actually comes from the reporter
        # and includes both the find and the vetting of the file - which failed
        expect{ @t.search }.to output( "\e[0;32;49m\tFound test directory at #{ pref }\e[0m\n" ).to_stdout
      end
      
      it "should report not finding" do
        allow(Dir).to receive(:glob).and_return([], [])
  
        # Note that the output actually comes from the reporter
        expect{ @t.search }.to output( "\e[0;31;49m\tWhere is the test directory?\e[0m\n" ).to_stdout        
      end
      
      it "should not report folders as problems" do
        allow(Dir).to receive(:glob).with("#{ @cur }/**/test").and_return(["#{ @cur }/test"])
        allow(Dir).to receive(:entries).and_return(['.', '..', "some_test_folder"])
        d = instance_double("FileInfo")
        allow(d).to receive(:stats).with(:is_directory?).and_return(true)
        
        # If it includes the second message in the output, it's a mistake
        expect{ @t.search }.to_not output("\e[0;32;49m\tFound test directory at /home/irv/work/with_ethics/test\e[0m\n\e[0;31;49m\t\tFound a problem with test file /home/irv/work/with_ethics/test/some_test_folder!\e[0m\n").to_stdout
      end
    end
  end
end