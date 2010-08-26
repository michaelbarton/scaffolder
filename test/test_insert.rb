require 'helper'

class TestInsert < Test::Unit::TestCase
  context Scaffolder::Base::Insert do

    setup do
      @options = {
        :start    => 1,
        :stop     => 5,
        :sequence => "ATGC"
      }
    end

    should "correctly store the passed options" do
      i = Scaffolder::Base::Insert.new @options
      assert_equal(i.start, 1)
      assert_equal(i.stop, 5)
      assert_equal(i.sequence, "ATGC")
      assert_equal(i.position, 0..4)
    end

    should "estimate the sequence end position" do
      @options.delete(:stop)
      i = Scaffolder::Base::Insert.new @options
      assert_equal(i.stop, 4)
    end

    should "be comparable by end position" do
      a = Scaffolder::Base::Insert.new @options
      b = Scaffolder::Base::Insert.new @options.merge(:stop => 6)
      c = Scaffolder::Base::Insert.new @options.merge(:stop => 7)
      assert_equal([c,a,b].sort, [a,b,c])
    end

  end
end
