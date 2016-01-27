require_relative "spec_helper"

module WithEthics
  describe Tcheck do
    describe "init" do
      it "should have ruby defaults" do
        t = Tcheck.new
        expect(t.target).to eq('ruby')
      end
      
      it "should pick default folders" do
        pt = ['test', 'spec']
        t = Tcheck.new paths: pt 
        expect(t.paths).to eq(pt)
      end
      
      it "should accept reporter" do
        rep = Reporter.new output_to: []
        t = Tcheck.new reporter: rep
        expect(t.reporter).to be(rep)
      end
    end
    
    describe "search" do
      before do
        @t = Tcheck.new reporter: Reporter.new(output_to: [])
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