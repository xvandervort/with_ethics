require 'spec_helper'

module WithEthics
  describe Reporter do
    before do
      @r = Reporter.instance
    end
    
    it "should config with defaults" do
      @r.config output_to: ['console']
      expect(@r.output_to).to eq(['console'])
    end
    
    it "should update family" do
      @r.config
      pf = "promised_files"
      # note codes to colorize output included
      expect{@r.family = pf}.to output("\e[0;34;49mCheck family #{ pf }\e[0m\n").to_stdout
      expect(@r.current_check_family).to eq(pf)
    end
    
    it "should output check passed message to stdout" do
      @r.config
      f = "CODE_OF_CONDUCT.md"
      # The light is green, the test is clean.
      expect{ @r.report(f, true) }.to output( "\e[0;32;49m\tFound #{ f }\e[0m\n").to_stdout
    end
    
    it "should output check failed message to stdout" do
      @r.config
      f = "CODE_OF_CONDUCT.md"
      # The light is red, the test is dead.
      expect{ @r.report(f, false) }.to output( "\e[0;31;49m\tWhere is #{ f }?\e[0m\n").to_stdout
    end
    
    # Why would you do that? To have the summary only!
    it "should suppress output if told" do
      @r.config output_to: []
      expect(@r.output_to).to be_empty
      expect { @r.report("some file", true) }.to output("").to_stdout
    end
    
    # for printing when the "finalize" or "output summary" method is called
    it "should keep summary of results" do
      @r.config output_to: []
      pf = "promised_files"
      @r.family = pf
      f = "CODE_OF_CONDUCT.md"
      @r.report(f, true)
      expect(@r.progress.keys).to include(pf)
      expect(@r.progress[pf].last.message).to eq("\e[0;32;49m\tFound CODE_OF_CONDUCT.md\e[0m")
      expect(@r.progress[pf].last.status).to eq(true)
    end
    
    it "should report problems" do
      @r.config
      
      expect{ @r.report_problem("some file")}.to output("\e[0;31;49m\t\tFound a problem with some file!\e[0m\n").to_stdout
    end
    
    it "should pass through reported messages" do
      @r.config
      expect{ @r.report_message("Nevermore!", true)}.to output("\e[0;32;49mNevermore!\e[0m\n").to_stdout
    end
  end
end