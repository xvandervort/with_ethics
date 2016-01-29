require 'spec_helper'

module WithEthics
  describe TypeFinder do
    
    describe "general" do
      it "should include readme" do
        expect { TypeFinder.new :readme }.not_to raise_error
      end
      
      it "should init given type" do
        df = TypeFinder.new :readme
        expect(df.finders).to be_kind_of(Array)
      end
      
      it "should remember known types" do
        expect(TypeFinder::KNOWN).to be_kind_of(Array)
      end
      
      it "should report unknown type when no regex given" do
        expect { TypeFinder.new :gibberish }.to raise_error(ArgumentError).with_message(/Unknown file type: gibberish/)
      end
      
      it "should configure finder from input" do
        pattern = '^supper$'
        expect { @tf = TypeFinder.new :supper, finder: pattern}.not_to raise_error
        expect(@tf.finders).to eq([pattern])
      end
    end
    
    describe "types" do
      it "should know readme" do
        expect { @df = TypeFinder.new :readme }.not_to raise_error
        expect(@df.finders.size).to be > 0
        expect(@df.finders.first).to match("Readme.rdoc")
      end
      
      it "should know test files" do
        expect { @df = TypeFinder.new :test }.not_to raise_error
        expect(@df.finders.size).to be > 0
        expect(@df.finders.first).to match("something_test.rb")
      end
      
      it "should know spec files" do
        @df = TypeFinder.new :test 
        expect(@df.finders.size).to be > 0
        expect(@df.finders[1]).to match("something_spec.rb")
      end
      
      it "should know privacy files" do
        expect{ @df = TypeFinder.new :privacy }.not_to raise_error
        expect(@df.finders.first).to match("privacy_policy.doc")
        # but does it match views? It does!
        expect(@df.finders.first).to match("_privacy_policy.html.erb")
      end
      
      it "should know code of conduct" do
        expect{ @df = TypeFinder.new :coc }.not_to raise_error
        expect(@df.finders.first).to match("CODE_OF_CONDUCT.md")
      end
      
      it "should know license file" do
        expect{ @df = TypeFinder.new :license }.not_to raise_error
        expect(@df.finders.first).to match("license.txt")
      end
      
      it "should know deploy file" do
        expect{ @df = TypeFinder.new :deploy }.not_to raise_error
        expect(@df.finders.first).to match("deploy.rb") 
      end
      
      it "should know gemfile" do
        expect{ @df = TypeFinder.new :gemfile }.not_to raise_error
        expect(@df.finders.first).to match("Gemfile") 
      end
    end
  end
end