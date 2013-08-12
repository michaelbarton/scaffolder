require 'helper'

describe Scaffolder do

  Scaffolder::Region::Mock = Class.new(Scaffolder::Region)

  before do
    @sequence = nil
    @data = [{'mock' => Hash.new}]
  end

  describe 'parsing a scaffold file' do

    before do
      Bio::FlatFile.stubs(:auto).with(@sequence).returns({})
    end

    it "should fetch correct region class type" do
      Scaffolder::Region.expects(:'[]').with('mock').returns(Scaffolder::Region::Mock)
      Scaffolder.new(@data,@sequence)
    end

    it "should pass data to region object" do
      Scaffolder::Region::Mock.expects(:generate).with(@data.first['mock'])
      Scaffolder.new(@data,@sequence)
    end

  end

  context 'parsing a scaffold file with a source keyword' do

    before do
      Bio::FlatFile.stubs(:auto).with(@sequence).returns([
                                                         stub(:definition => 'seq1', :seq => 'ATGC')])
    end

    it "should should also pass raw_sequence from flat file" do
      @data.first['mock']['source'] = 'seq1'
      Scaffolder::Region::Mock.any_instance.expects(:source).with('seq1')
      Scaffolder::Region::Mock.any_instance.expects(:raw_sequence).with('ATGC')
      Scaffolder.new(@data,@sequence)
    end

  end

  context 'updating each data hash with raw_sequence attributes' do

    before do
      @seqs = {'seq1' => 'AAA'}
      @expected = {'source' => 'seq1', 'raw_sequence' => @seqs['seq1']}
    end

    it "should do nothing when no source keyword" do
      test = {'something' => 'nothing'}
      Scaffolder.update_with_sequence(test,@seqs).should == test
    end

    it "should add raw_sequence to simple hash" do
      test = {'source' => 'seq1'}
      Scaffolder.update_with_sequence(test,@seqs).should == @expected
    end

    it "should add raw_sequence to a nested hash" do
      test     = {'something' => {'source' => 'seq1'}}
      expected = {'something' => @expected}
      Scaffolder.update_with_sequence(test,@seqs).should == expected
    end

    it "should add raw_sequence to a twice nested hash" do
      test     = {'something' => {'other' => {'source' => 'seq1'}}}
      expected = {'something' => {'other' => @expected}}
      Scaffolder.update_with_sequence(test,@seqs).should == expected
    end

    it "should add raw_sequence to simple hash inside an array" do
      test     = [{'source' => 'seq1'}]
      expected = [@expected]
      Scaffolder.update_with_sequence(test,@seqs).should == expected
    end

    it "should add raw_sequence to a nested hash inside an array" do
      test     = {'something' => [{'source' => 'seq1'}]}
      expected = {'something' => [@expected]}
      Scaffolder.update_with_sequence(test,@seqs).should == expected
    end

    it "should add raw_sequence to two nested hashes inside an array" do
      test     = {'something' => [{'source' => 'seq1'},{'source' => 'seq1'}]}
      expected = {'something' => [@expected,@expected]}
      Scaffolder.update_with_sequence(test,@seqs).should == expected
    end

    it "should add raw_sequence to a hash inside a hash inside an array" do
      test     = {'something' => [{'else' => {'source' => 'seq1'}}]}
      expected = {'something' => [{'else' => @expected}]}
      Scaffolder.update_with_sequence(test,@seqs).should == expected
    end

    it "should add raw_sequence to a twice nested (hash inside an array)" do
      test     = {'something' => [{'else' => [{'source' => 'seq1'}]}]}
      expected = {'something' => [{'else' => [@expected]}]}
      Scaffolder.update_with_sequence(test,@seqs).should == expected
    end

    it "should throw an UnknownSequenceError when no matching sequence" do
      test = {'source' => 'non_existent_sequence'}
      lambda{ Scaffolder.update_with_sequence(test,@seqs)}.should raise_error(Scaffolder::Errors::UnknownSequenceError)
    end

  end

end
