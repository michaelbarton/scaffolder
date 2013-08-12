require 'helper'

describe Scaffolder::Region::Sequence do

  its(:class){ should respond_to(:attribute)}
  it{ should respond_to :source, :inserts}
  
  describe "insert attribute method" do

    let(:coordinates) do
      {'open' => 2, 'close' => 3}
    end

    let(:insert) do
      i = Scaffolder::Region::Insert.new
      i.open  coordinates['open']
      i.close coordinates['close']
      i
    end

    it "should return empty array as default value" do
      subject.inserts.should be_empty
    end

    it "should allow array of inserts to be set as value" do
      subject.inserts [insert]
      subject.inserts.first.should == insert
    end

    it "should process insert data hash into an array of inserts" do
      subject.inserts [coordinates]
      ins = subject.inserts.first
      ins.should be_instance_of Scaffolder::Region::Insert

      ins.close.should == coordinates['close']
      ins.open.should == coordinates['open']
    end

    it "should process mixed insert data into an array of inserts" do
      subject.inserts [coordinates,insert]

      subject.inserts.each do |ins|
        ins.should be_instance_of Scaffolder::Region::Insert
        ins.close.should == coordinates['close']
        ins.open.should == coordinates['open']
      end
    end

  end

  describe "with inserts added" do

    before do
      subject.raw_sequence 'ATGCCAGATAACTGACTAGCATG'
    end

    let(:insert) do
      ins = Scaffolder::Region::Insert.new
      ins.raw_sequence 'GGTAGTA'
      ins.open  5
      ins.close 10
      ins
    end

    it "should raise when the insert open is after the sequence stop" do
      insert.open 24
      insert.close 25
      subject.inserts [insert]
      lambda{subject.sequence}.should raise_error(Scaffolder::Errors::CoordinateError)
    end

    it "should raise when the insert close is before the sequence start" do
      insert.open -5
      insert.close 0
      subject.inserts [insert]
      lambda{subject.sequence}.should raise_error(Scaffolder::Errors::CoordinateError)
    end

    it "should raise when the insert open is greater than the insert close" do
      insert.open 11
      subject.inserts [insert]
      lambda{subject.sequence}.should raise_error(Scaffolder::Errors::CoordinateError)
    end

    it "should update the sequence with a simple insert" do
      subject.inserts [insert]
      subject.sequence.should == 'ATGCGGTAGTAACTGACTAGCATG'
    end

    it "should update the sequence with a simple insert with repeated method calls" do
      subject.inserts [insert]
      subject.sequence.should == 'ATGCGGTAGTAACTGACTAGCATG'
      subject.sequence.should == 'ATGCGGTAGTAACTGACTAGCATG'
    end

    it "should update the sequence stop position after adding a simple insert" do
      subject.inserts [insert]
      subject.stop.should == 24
    end

    it "should update the sequence with inserts in reverse order" do
      insert_two = insert.clone
      insert_two.open 12
      insert_two.close 15
      subject.inserts [insert,insert_two]
      subject.sequence.should == "ATGCGGTAGTAAGGTAGTACTAGCATG"
    end
  end

end
