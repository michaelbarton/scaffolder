require 'helper'

describe Scaffolder::Region::Unresolved do

  its(:class){ should respond_to(:attribute)}
  it{ should respond_to :length}
  
  it "should return unresolved sequence when given length" do
    subject.length 5
    subject.sequence.should == ('N' * 5)
  end

  it "raise an error if length is unspecified" do
    lambda{ subject.sequence }.should raise_error(Scaffolder::Errors::CoordinateError)
  end

end
