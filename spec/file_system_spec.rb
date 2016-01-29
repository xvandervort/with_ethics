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
        expect{ @fs = FileSystem.new root: @r, reporter: Reporter.new(output_to: [])}.to_not raise_error
        expect(@fs.reporter).to be_kind_of(Reporter)
      end
    end
    
    describe "finding" do
      before do
        @r = Dir.pwd
        @fs = FileSystem.new root: @r, reporter: Reporter.new(output_to: [])
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
        fs2 = FileSystem.new root: @r, reporter: Reporter.new
        expect{ fs2.find :readme }.to output("\e[0;32;49m\tFound /home/irv/work/with_ethics/README.md\e[0m\n").to_stdout
      end
    end
  end
end