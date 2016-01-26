require 'spec_helper'

module WithEthics
  describe FileInfo do
    it "should accept filename" do
      ff = FileInfo.new name: "file.txt"
      expect(ff.name).to eq("file.txt")
    end
    
    it "should infer path when not give" do
      ff = FileInfo.new name: "file.txt"
      expect(ff.path).to eq(Dir.pwd)
    end
    
    it "should replace @root with local path" do
      ff = FileInfo.new name: "file.txt", path: "@root/somewhere"
      expect(ff.path).to eq("#{ Dir.pwd }/somewhere")
    end
    
    it "should give correct full path" do
      ff = FileInfo.new name: "file.txt", path: "@root/somewhere"
      expect(ff.fullpath).to eq("#{ Dir.pwd }/somewhere/file.txt")
    end
    
    describe "stat operations" do
      
      before do
        # I added a code of conduct file to this project
        # just so I wouldn't have to continually mock out checks for it.
        # Though theoretically, it would be cleaner to avoid these interactions
        # with the file system.
        @filename = 'CODE_OF_CONDUCT.md'
        @path = '@root'
        @ff = FileInfo.new name: @filename, path: @path
      end
    
      it "should look for the file at the path and find it" do
        expect(@ff.check_for_file).to eq(true)
      end
      
      it "should check that file size is greater than zero" do
        @ff.file_stats
        expect(@ff.stats[:size]).to be > 0
      end
      
      it "should know file is missing" do
        # and yet, mocking is still needed!
        allow(File).to receive(:exist?).and_return(false)
        expect(@ff.check_for_file).to eq(false)
      end
     
      it "should know file is a file and not a dirctory" do
        @ff.file_stats
        expect(@ff.stats[:is_file]).to eq(true)
        expect(@ff.stats[:is_directory]).to eq(false)
      end

      it "should say if file is useable" do
        expect(@ff.can_be_used?).to be(true)
      end
      
      it "should return false for non existent files" do
        pf = PromisedFile.new filename: "iDoNotExist.txt", path: @path
        expect(pf.can_be_used?).to be(false)
      end
      
      it "should fill stats when told to get" do
        s = @ff.get_stats
        expect(s).to be_kind_of(Hash)
        expect(s[:is_file]).to eq(true) 
      end
    end
    
    describe "with wildcards" do
      it "should fill paths when given a filename with a wildcard" do
        ff = FileInfo.new name: "*.md"
        expect(ff.paths).to be_kind_of(Array)
        expect(ff.paths).to_not be_empty
        expect(ff.paths).to include("#{ Dir.pwd }/README.md")
      end
      
      it "should iterate through paths" do
        ff = FileInfo.new name: "*.md"  # normally there will be 2
        expect{
          ff.each_path do |pth|
            expect(pth).to be_kind_of FileInfo
            expect(pth.can_be_used?).to eq(true)
          end
        }.not_to raise_error
      end
    end
  end
end