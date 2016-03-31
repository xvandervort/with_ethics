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
      before do
        d = Time.now - 37.hours 
        rec = double(Git::Object::Commit, date: d)
        glog = double(Git::Log, first: rec)
        allow(@git).to receive(:log).and_return(glog)
        gstat = double(Git::Status, changed: { "somefile" => 'dummy' }, added: { "someotherfile" => 'dummy' })
        allow(@git).to receive(:status).and_return(gstat)
        @g.log_info
        @g.status_info
      end
      
      # rather than feed the damned report object into this thing
      # have it spit out a report. Simple report = 1 line.
      it "should give simple report" do
        # There will be 3 levels of output. Simplest - one line only, medium, more detailed, and verbose.
        simple_output = @g.results
        expect(simple_output).to be_kind_of Hash
        expect(simple_output).to have_key(:summary)
        expect(simple_output[:summary]).to_not be_nil
      end
      
      # more verbose output
      it "should give detailed summary" do
        dout = @g.results(verbose: true)
        expect(dout).to have_key(:age)
        expect(dout).to have_key(:changes)
        expect(dout).to have_key(:missing)
      end
    end
  end
end