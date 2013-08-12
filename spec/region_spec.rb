require 'helper'

describe Scaffolder::Region do

  describe "adding instance methods with attribute method" do

    let(:attr){ :some_attribute }

    it "should create a single accessor attribute" do
      Scaffolder::Region.attribute attr
      methods = Scaffolder::Region.instance_methods.map{|m| m.to_s}
      expect(methods).to include(attr.to_s)
    end

    it "should return nil until attribute value is stored" do
      Scaffolder::Region.attribute attr
      region = Scaffolder::Region.new
      region.send(attr).should be_nil
      region.send(attr,5)
      region.send(attr).should == 5
    end

    it "should allow specification of default value" do
      Scaffolder::Region.attribute attr, :default => 1
      region = Scaffolder::Region.new
      region.send(attr).should == 1
      region.send(attr,5)
      region.send(attr).should == 5
    end

    it "should allow specification of default value using a block" do
      Scaffolder::Region.attribute attr, :default => lambda{|s| s.entry_type }
      region = Scaffolder::Region.new
      region.send(attr).should == region.entry_type
      region.send(attr,5)
      region.send(attr).should == 5
    end

  end

  describe "passing the yaml hash to the generate method" do

    let(:tags) do
      {'one' => 1, 'two' => 2}
    end

    before do
      Scaffolder::Region.attribute(:one)
      Scaffolder::Region.attribute(:two)
    end

    it "should should call each tag in the hash as a method to store the value" do
      Scaffolder::Region.any_instance.expects(:one).with(1)
      Scaffolder::Region.any_instance.expects(:two).with(2)
      Scaffolder::Region.generate(tags)
    end

    it "should return an instantiated region object" do
      region = Scaffolder::Region.generate(tags)
      region.one.should == 1
      region.two.should == 2
    end

    it "should throw UnknownAttributeError for an unknown attribute" do
        lambda{ Scaffolder::Region.generate({:three => 3}) }.should \
          raise_error(Scaffolder::Errors::UnknownAttributeError)
    end

  end

  context "attributes" do

    it{ should respond_to :start, :stop, :reverse, :raw_sequence }

    it "should return the class name as the entry type" do
      Scaffolder::Region::NewRegion = Class.new(Scaffolder::Region)
      Scaffolder::Region::NewRegion.new.entry_type.should == :newregion
    end

    it "should return 1 as default value for start attribute" do
      sequence = Scaffolder::Region.new
      sequence.start.should == 1
    end

    it "should return #raw_sequence length as default value for stop attribute" do
      length = 5
      subject.raw_sequence('N' * length)
      subject.stop.should == length
    end

  end

  describe "generating the processed sequence" do

    [:sequence_hook, :raw_sequence].each do |method|

      context "using the #{method} method" do

        let(:region) do
          # Test class to prevent interference with other tests
          s = Class.new(Scaffolder::Region).new
          s.class.send(:define_method,method,lambda{'ATGCCAGATAACTGACTAGCATG'})
          s
        end

        it "should return the sequence when no other options are passed" do
          region.sequence.should == 'ATGCCAGATAACTGACTAGCATG'
        end

        it "should reverse complement sequence when passed the reverse option" do
          region.reverse true
          region.sequence.should == 'CATGCTAGTCAGTTATCTGGCAT'
        end

        it "should create subsequence when passed sequence coordinates" do
          region.start 5
          region.stop 20
          region.sequence.should == 'CAGATAACTGACTAGC'
        end

        it "should raise a CoordinateError when start is less than 1" do
          region.start 0
          lambda{ region.sequence }.should raise_error(Scaffolder::Errors::CoordinateError)
        end

        it "should raise a CoordinateError when stop is greater than sequence " do
          region.stop 24
          lambda{region.sequence}.should raise_error(Scaffolder::Errors::CoordinateError)
        end

        it "should raise a CoordinateError when stop is greater than start " do
          region.start 6
          region.stop 5
          lambda{ region.sequence }.should raise_error(Scaffolder::Errors::CoordinateError)
        end

      end

    end

  end

  it "should instantiate return corresponding region subclass when requested" do
    Scaffolder::Region::Type = Class.new
    Scaffolder::Region['type'].should == Scaffolder::Region::Type
  end

end
