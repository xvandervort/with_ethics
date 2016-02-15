require 'spec_helper'

module WithEthics
  describe Repo do
    describe "init" do
      before do
        @reporter = Reporter.instance
        @reporter.config
      end
      
      it "should instantiate" do
        expect{ Repo.new reporter: @reporter}.not_to raise_error
      end
      
      it "should accept 'git' as a type to find" do
        r = Repo.new type: 'git', reporter: @reporter
        expect(r.type).to eq('git')
      end
      
      # does it make sense that if a reporter is not provided, just don't report? Not really!
      it "should accept a reporter" do
        r = Repo.new reporter: @reporter
        expect(r.reporter).to be_kind_of Reporter
      end
      
      it "should accept root" do
        root = '/some/path'
        r = Repo.new root: root, reporter: @reporter
        expect(r.root).to eq(root)
      end
    end
  end
  
  describe "git" do
    before do
      @reporter = Reporter.instance
      @reporter.config
      @repo = Repo.new type: 'git', reporter: @reporter
    end
    
    it "should find git repo" do
       expect {
         expect(@repo.find).to eq(true)
      }.to output("\e[0;32;49m\tFound git repository\e[0m\n").to_stdout
      # suppress damned output!
    end
    
    it "should report finding git repo" do
      expect { @repo.find }.to output("\e[0;32;49m\tFound git repository\e[0m\n").to_stdout
      
    end
  end
  
  describe "subversion" do
    before do
      @reporter = Reporter.instance
      @reporter.config output_to: []
      @repo = Repo.new type: 'svn', reporter: @reporter
    end
    
    it "should not find locally" do
      expect(@repo.find).to eq(false)
    end
    
    it "should find when present" do
      # I know it's sort of a tautology but
      # how'm I going to test a subversion repository
      # from a git based project?
      path = "#{ Dir.pwd }/.svn"
      allow(File).to receive(:exists?).with(path).and_return(true)
      allow(File).to receive(:directory?).with(path).and_return(true)
      expect(@repo.find).to eq(true)
    end
  end
end