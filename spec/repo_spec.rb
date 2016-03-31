require 'spec_helper'
require 'active_support/core_ext/date'

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
    
    it "should report simple git repo status" do
      gstat = double(Git::Status, changed: {}, added: {})
      git = double(Git::Base, status_hint: 'good', results: { summary: "Repository is in good condition." }, log: {}, status: gstat)
      allow(Git).to receive(:open).and_return(git)
      expect { @repo.status }.to output("\e[0;32;49m\tRepository is in good condition.\e[0m\n").to_stdout
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
    
    # SVN keeps a .svn directory in every directory throughout the repo
    # so just seeing it at the top level isn't good enough. You have to check
    # all the way down.
    it "confirms svn repo recursively"
  end
  
  describe "mercurial" do
    before do
      @reporter = Reporter.instance
      @reporter.config output_to: []
      @repo = Repo.new type: 'hg', reporter: @reporter
    end
    
    it "should find when present" do
      # I know it's sort of a tautology but
      # how'm I going to test a subversion repository
      # from a git based project?
      path = "#{ Dir.pwd }/.hg"
      allow(File).to receive(:exists?).with(path).and_return(true)
      allow(File).to receive(:directory?).with(path).and_return(true)
      expect(@repo.find).to eq(true)
    end
  end
  
    
  describe "unknown version control" do
    
    it "should find known type without spec" do
      %w(hg svn git).each do |t|
        path = "#{ Dir.pwd }/.#{ t }"
        val = (t == 'svn')
        allow(File).to receive(:exists?).with(path).and_return(val)
        allow(File).to receive(:directory?).with(path).and_return(val)
        
      end
      @reporter = Reporter.instance
      @reporter.config
      @repo = Repo.new type: nil, reporter: @reporter
      expect { @repo.find }.to output("\e[0;32;49m\tFound svn repository\e[0m\n").to_stdout
    end
  end

end