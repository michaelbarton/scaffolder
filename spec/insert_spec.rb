require 'helper'

describe Scaffolder::Region::Insert do

  describe "attributes" do

    its(:class){ should respond_to(:attribute)}
    it{ should respond_to :source, :open, :close}

    let(:length){ 15 }

    before do
      subject.raw_sequence('N' * length)
    end

    it "should return open plus sequence length as default close" do
      subject.open 5
      subject.close.should == (subject.open + length - 1)
    end

    it "should return close minus sequence length as default open" do
      subject.close 20
      subject.open.should == (subject.close - length - 1)
    end

    it "should include the insert position" do
      subject.open  5
      subject.close 10
      subject.position.should == (4..9)
    end

    it "should throw an error when neither open or close are provided" do
      lambda{subject.position}.should raise_error(Scaffolder::Errors::CoordinateError)
    end

  end

  describe "#size_diff" do

    before do
      subject.open  3
      subject.close 5
    end

    it "should return a negative diff for a sequence smaller than insert site" do
      subject.raw_sequence 'TT'
      subject.size_diff.should == -1
    end

    it "should return 0 for a sequence equal to the insert site" do
      subject.raw_sequence 'TTT'
      subject.size_diff.should == 0
    end

    it "should return a positive diff for a sequence larger than insert site" do
      subject.raw_sequence 'TTTT'
      subject.size_diff.should == 1
    end

  end

  it "should be comparable by close position" do
    a = subject
    a.close 1

    b = subject.clone
    b.close 2

    c = subject.clone
    c.close 3

    [c,a,b].sort.should == [a,b,c]
  end

end
