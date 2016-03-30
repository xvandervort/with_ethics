require 'spec_helper'
require 'git'
require 'active_support/core_ext/numeric/time'

module WithEthics
  describe Gitvc do
    before do
      @pth = "/some/path"
      @git = double(Git::Base)
      allow(Git).to receive(:open).and_return(@git)
      @g = Gitvc.new @pth
    end
    
    describe "init" do
      it "should initialize with base path" do  
        expect(@g.path).to eq(@pth)
      end
    
      it "should initalize git object" do
        expect(@g.git).to_not be_nil
      end
    end
    
    describe "interrogation" do
      it "should record empty git log" do
        allow(@git).to receive(:log).and_raise(Git::GitExecuteError)
        @g.log_info
        expect(@g.status).to eq(["empty"])
        expect(@g.last_commit).to eq(nil)
      end
      
      it "should record recent commit" do
        d = Time.now - 37.hours 
        rec = double(Git::Object::Commit, date: d)
        glog = double(Git::Log, first: rec)
        allow(@git).to receive(:log).and_return(glog)
        @g.log_info
        expect(@g.status).to eq(["initialized"])
        expect(@g.last_commit).to eq(d)
      end
      
      it "should see uncommitted changes" do
        gstat = double(Git::Status, changed: { 'somefile.txt' => 'dummy' }, added: {})
        allow(@git).to receive(:status).and_return(gstat)
        @g.status_info
        expect(@g.status).to include("changes")
        expect(@g.changed).to eq(1)
      end
      
      it "should see untracked files" do
        gstat = double(Git::Status, changed: { }, added: { 'somefile.txt' => 'dummy' })
        allow(@git).to receive(:status).and_return(gstat)
        @g.status_info
        expect(@g.status).to include("untracked")
        expect(@g.untracked).to eq(1)
      end
      
      it "should see lack of uncommitted or untracked files" do
        gstat = double(Git::Status, changed: { }, added: {})
        allow(@git).to receive(:status).and_return(gstat)
        @g.status_info
        expect(@g.status).to include("up to date")
        expect(@g.changed).to eq(0)
        expect(@g.untracked).to eq(0)
      end
    end
    
    describe "reporting" do
      # rather than feed the damned report object into this thing
      # have it spit out a report. Simple report = 1 line. Verbose report goes into a little more depth
      
      
    end
  end
end