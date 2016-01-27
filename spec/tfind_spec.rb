require_relative "spec_helper"

module WithEthics
  describe Tfind do
    describe "init" do
      it "should have ruby defaults" do
        t = Tfind.new
        expect(t.target).to eq('ruby')
      end
      
      it "should pick default folders" do
        pt = ['test', 'spec']
        t = Tfind.new paths: pt 
        expect(t.paths).to eq(pt)
      end
    end
    
    describe "search" do
      before do
        @t = Tfind.new 
      end
      
      it "should find easy test folder" do
        cur = Dir.pwd
        allow(Dir).to receive(:glob).with("#{ cur }/**/test").and_return("#{ cur }/test")
        allow(Dir).to receive(:entries).and_return(['.', '..', "some_test.rb"])

        pref = "#{ cur }/test"
        expect(@t.search).to eq([pref, ["#{ pref }/some_test.rb"]] )
      end
      
      it "should find lower level test folder" do
        cur = Dir.pwd
        allow(Dir).to receive(:glob).with("#{ cur }/**/test").and_return("#{ cur }/one/test")
        allow(Dir).to receive(:entries).and_return(['.', '..', "some_test.rb"])

        pref = "#{ cur }/one/test"
        expect(@t.search).to eq([pref, ["#{ pref }/some_test.rb"]] )
      end
    end
  end
end