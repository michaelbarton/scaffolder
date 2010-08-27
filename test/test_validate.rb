require 'helper'

class TestValidate < Test::Unit::TestCase
  context Scaffolder do

    setup do
      @valid   = OpenStruct.new(:entry_type => :sequence, :valid? => true)
      @invalid = OpenStruct.new(:entry_type => :sequence, :valid? => false)
    end

    context "a scaffold with two valid sequences" do
      setup do
        @scaffold = empty_scaffold
        mock(@scaffold).layout.returns([@valid,@valid])
      end

      should "be valid" do
        assert_equal(@scaffold.valid?, true)
      end
    end

    context "a scaffold with a mixture of valid and invalid sequences" do
      setup do
        @scaffold = empty_scaffold
        mock(@scaffold).layout.returns([@valid,@invalid])
      end

      should "not be valid" do
        assert_equal(@scaffold.valid?, false)
      end

      should "return the erroneous sequence" do
        assert_equal(@scaffold.errors,[@invalid])
      end

    end

  end
end
