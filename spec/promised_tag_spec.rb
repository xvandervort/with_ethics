require 'spec_helper'

module WithEthics
  describe PromisedTag do
    
    describe "init" do
      it "should accept tag to search for" do
        tag = 'security'
        pt = PromisedTag.new tag: tag, name: 'x'
        expect(pt.tag).to eq(tag)
      end
      
      it "should accept path tag" do
        pt = PromisedTag.new tag: "tag", path: 'somewhere', name: 'x'
        expect(pt.path).to eq("somewhere")
      end
      
      it "should use default path if none given" do
        pt = PromisedTag.new tag: "tag", name: 'x'
        expect(pt.path).to eq(Dir.pwd)
      end
      
      it "should default to non-recursive search" do
        pt = PromisedTag.new tag: "tag", name: 'x'
        expect(pt.recursive_search).to eq(false)
      end
      
      it "should override recursive" do
        pt = PromisedTag.new tag: "tag", recurse: true, name: 'x'
        expect(pt.recursive_search).to eq(true)
      end
      
      it "should accept a reporter" do
        pt = PromisedTag.new tag: "tag", reporter: Reporter.instance, name: 'x'
        expect(pt.reporter).to be_kind_of(Reporter)
      end
      
      it "should fail without tag" do
        expect {
          PromisedTag.new name: 'x'
        }.to raise_error(ArgumentError)
      end
      
      it "should accept regular file name" do
        nm = "somename.txt"
        pt = PromisedTag.new tag: "tag", path: "@root/lib/with_ethics", name: nm
        expect(pt.name).to eq(nm)
      end
    end

    describe "tag search" do
      before do
        @rep = Reporter.instance
        @rep.config output_to: []
      end
      
      it "should find tag in one file" do                                   
        # end setup I hope
        pt = PromisedTag.new tag: 'security', name: 'somecode.rb', path: "@root/spec/files", reporter: @rep
        pt.search
        expect(pt.found).to eq(1)
      end
      
      it "should find tag in files using wildcard name" do
        pt = PromisedTag.new tag: 'security', name: '*.rb', path: "@root/spec/files", reporter: @rep
        pt.search
        expect(pt.found).to eq(1)
      end
      
      it "should report how many tags found" do
        # this is a naive report since the tag could be found
        # a hundred times in one file and not at all in another.
        @rep.family = "tags"
        @rep.config output_to: ['console']
        pt = PromisedTag.new tag: 'security', name: '*.rb', path: "@root/spec/files", reporter: @rep
        pt.search
        expect(pt.reporter.progress["tags"].first.message).to eq("\e[0;32;49m\tFound 'security' tag 1 time(s)\e[0m")
      end
    end
  end
end