require 'spec_helper'

module WithEthics
  describe FileSystem do
    
    describe "init" do
      before do
        @r = "/some/path"
      end
      
      it "should accept root path" do
        expect{ @fs = FileSystem.new root: @r}.not_to raise_error
        expect(@fs.root).to eq(@r)
      end
      
      it "should accept reporter" do
        rep = Reporter.instance
        rep.config output_to: []

        expect{ @fs = FileSystem.new root: @r, reporter: rep }.to_not raise_error
        expect(@fs.reporter).to be_kind_of(Reporter)
      end
    end
    
    describe "finding" do
      before do
        @r = Dir.pwd
        @rep = Reporter.instance
        @rep.config output_to: []
        @fs = FileSystem.new root: @r, reporter: @rep
      end
      
      it "should find default type" do
        expect{ @list = @fs.find :readme }.not_to raise_error
        expect(@list).to eq(["#{ @r }/README.md"])
      end
      
      it "should find custom type" do
        expect{ @list = @fs.find :gem, /with_ethics-.*.gem$/i }.not_to raise_error
        expect(@list.size).to be > 0
      end
      
      it "should find default type when more than one patttern" do
        @list = @fs.find :test
        
        # because "test" is the first pattern in the local project
        # but it uses specs
        expect(@list.size).to be > 0
      end
      
      it "should report findings" do
        @rep.config output_to: ['console'] # change the one thing you can
        fs2 = FileSystem.new root: @r, reporter: @rep
        expect{ fs2.find :readme }.to output("\e[0;32;49m\tFound /home/irv/work/with_ethics/README.md\e[0m\n").to_stdout
      end
    end
  end
end