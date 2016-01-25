require 'spec_helper'

module WithEthics
  describe PromisedTag do
    describe "init" do
      it "should accept tag to search for" do
        tag = 'security'
        pt = PromisedTag.new tag: tag, name: 'x'
        expect(pt.tag_list).to eq([tag])
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
        pt = PromisedTag.new tag: "tag", reporter: Reporter.new, name: 'x'
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
      it "should find tag in one file" do                                   
        # end setup I hope
        pt = PromisedTag.new tag: 'security', name: 'somecode.rb', path: "@root/spec/files"
        pt.search
        expect(pt.found).to eq(1)
      end
    end
  end
end