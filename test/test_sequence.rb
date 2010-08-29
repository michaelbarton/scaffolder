require 'helper'

class TestScaffolder < Test::Unit::TestCase
  context Scaffolder::Base::Sequence do

    setup do
      @options = { :name => "sequence1",
        :sequence => 'ATGCCAGATAACTGACTAGCATG' }
    end

    context "processing a simple sequence tag" do

      should "create sequence object" do
        sequence = Scaffolder::Base::Sequence.new @options
        assert_equal(sequence.entry_type,:sequence)
        assert_equal(sequence.start,1)
        assert_equal(sequence.end,23)
        assert_equal(sequence.name,'sequence1')
        assert_equal(sequence.sequence,'ATGCCAGATAACTGACTAGCATG')
      end

      should "reverse sequence when passed the reverse option" do
        sequence = Scaffolder::Base::Sequence.new @options.merge(:reverse => true)
        assert_equal(sequence.sequence,'TACGGTCTATTGACTGATCGTAC')
      end

      should "create subsequence object when passed sequence coordinates" do
        sequence = Scaffolder::Base::Sequence.new @options.merge(:start => 5,:end => 20)
        assert_equal(sequence.start,5)
        assert_equal(sequence.end,20)
        assert_equal(sequence.sequence,'CAGATAACTGACTAGC')
      end

      should "throw an error when the start position is outside the sequence length" do
        begin
          Scaffolder::Base::Sequence.new @options.merge(:start => 0)
          flunk "Should throw an argument error"
        rescue ArgumentError
        end
      end

      should "throw an error when the end position is outside the sequence length" do
        begin
          Scaffolder::Base::Sequence.new @options.merge(:end => 24)
          flunk "Should throw an argument error"
        rescue ArgumentError
        end
      end

      should "throw an error when the start is greater than the end" do
        begin
          Scaffolder::Base::Sequence.new @options.merge(:end => 5,:start => 10)
          flunk "Should throw an argument error"
        rescue ArgumentError
        end
      end

    end

    context "processing a sequence tag with inserts" do

      setup do
        @insert = {:start => 5, :stop => 10, :sequence => 'GGTAGTA'}
        @sequence = Scaffolder::Base::Sequence.new @options
      end

      should "raise when the insert start is after the sequence end" do
        @insert.update(:start => 24,:stop => nil)
        assert_raise(ArgumentError) do
          @sequence.add_inserts([Scaffolder::Base::Insert.new @insert])
        end
      end

      should "raise when the insert stop is before the sequence start" do
        @insert.update(:start => -5,:stop => 0)
        assert_raise(ArgumentError) do
          @sequence.add_inserts([Scaffolder::Base::Insert.new @insert])
        end
      end

      should "raise when insert start is greater than end" do
        @insert.update(:start => 11)
        assert_raise(ArgumentError) do
          @sequence.add_inserts([Scaffolder::Base::Insert.new @insert])
        end
      end

      should "update the sequence" do
        @sequence.add_inserts([Scaffolder::Base::Insert.new @insert])
        assert_equal(@sequence.sequence,'ATGCGGTAGTAACTGACTAGCATG')
        assert_equal(@sequence.end,24)
      end

      should "update the sequence when reversed" do
        @sequence = Scaffolder::Base::Sequence.new @options.update(:reverse => true)
        @sequence.add_inserts([Scaffolder::Base::Insert.new @insert])
        assert_equal(@sequence.sequence,"TACGCCATCATTGACTGATCGTAC")
      end

      should "update the sequence with two inserts" do
        @sequence.add_inserts([Scaffolder::Base::Insert.new(@insert),
          Scaffolder::Base::Insert.new(@insert.update(:start => 12, :stop => 15))])
        assert_equal(@sequence.sequence,"ATGCGGTAGTAAGGTAGTACTAGCATG")
        assert_equal(@sequence.end,27)
      end
    end

    context "validate sequence inserts for overlaps" do

      setup do
        @insert = {:start => 5, :stop => 10, :sequence => 'GGTAGTA'}
        @sequence = Scaffolder::Base::Sequence.new @options
      end

      should "be valid when inserts don't overlap" do
        @no_overlap = {:start => 12, :stop => 13, :sequence => 'GGTAGTA'}
        @sequence.add_inserts([Scaffolder::Base::Insert.new(@insert),
                               Scaffolder::Base::Insert.new(@no_overlap)])
        assert_equal(@sequence.valid?,true)
      end

      should "return no error messages when inserts don't overlap" do
        @no_overlap = {:start => 12, :stop => 13, :sequence => 'GGTAGTA'}
        @sequence.add_inserts([Scaffolder::Base::Insert.new(@insert),
                               Scaffolder::Base::Insert.new(@no_overlap)])
        assert(@sequence.errors.empty?)
      end

      should "not be valid when inserts overlap" do
        @overlap = {:start => 10, :stop => 11, :sequence => 'GGTAGTA'}
        @sequence.add_inserts([Scaffolder::Base::Insert.new(@insert),
                               Scaffolder::Base::Insert.new(@overlap)])
        assert_equal(@sequence.valid?,false)
      end

      should "return an error message when inserts overlap" do
        @overlap = {:start => 10, :stop => 11, :sequence => 'GGTAGTA'}
        inserts = [Scaffolder::Base::Insert.new(@insert),
                   Scaffolder::Base::Insert.new(@overlap)]
        @sequence.add_inserts(inserts)
        assert_equal(@sequence.errors,[inserts.sort])
      end

    end
  end
end
