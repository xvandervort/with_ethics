require 'spec_helper'

module WithEthics
  describe PromisedFile do
    before do
      # I added a code of conduct file to this project
      # just so I wouldn't have to continually mock out checks for it.
      # Though theoretically, it would be cleaner to avoid these interactions
      # with the file system.
      @filename = 'CODE_OF_CONDUCT.md'
      @path = 'root'
      @pf = PromisedFile.new filename: @filename, path: @path
    end
    
    it "should initialize with data" do
      expect(@pf).to be_kind_of(PromisedFile)
      expect(@pf.filename).to eq(@filename)
      expect(@pf.path).to_not be_nil
    end
    
    it "should translate root to current path" do
      expect(@pf.path).to eq(Dir.pwd)
    end
    
    it "should use current dir if not path given" do
      pf2 = PromisedFile.new filename: @filename
      expect(pf2.path).to eq(Dir.pwd)
    end
    
    it "should look for the file at the path and find it" do
      expect(@pf.check_for_file).to eq(true)
    end
    
    it "should check that file size is greater than zero" do
      @pf.file_stats
      expect(@pf.stats[:size]).to be > 0
    end
    
    it "should know file is missing" do
      # and yet, mocking is still needed!
      allow(File).to receive(:exist?).and_return(false)
      expect(@pf.check_for_file).to eq(false)
    end
    
    it "should know file is a file and not a dirctory" do
      @pf.file_stats
      expect(@pf.stats[:is_file]).to eq(true)
      expect(@pf.stats[:is_directory]).to eq(false)
    end
    
    it "should check file is under version control"
    it "should search below given path for missing file"
  end
end