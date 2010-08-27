require 'helper'

class TestScaffolder < Test::Unit::TestCase
  context Scaffolder do
    
    setup do
      @sequence = File.join(File.dirname(__FILE__),'data','sequences.fna')
      @assembly = [ {"sequence" => { "source" => "sequence1" } } ]
      @expect = {:name => 'sequence1', :start => nil, :end => nil,
        :sequence => 'ATGCCAGATAACTGACTAGCATG', :reverse => nil}
    end

    context "when parsing a sequence tag" do

      should "create sequence" do
        mock(Scaffolder::Base::Sequence).new(@expect)
        scaffold = Scaffolder.new @assembly, @sequence
        assert_equal(scaffold.layout.length, 1)
      end

      should "create sequence with coordinates" do
        @assembly.first['sequence'].update('start' => 2, 'end' => 5)
        mock(Scaffolder::Base::Sequence).new(@expect.update({:start => 2, :end => 5 }))
        scaffold = Scaffolder.new @assembly, @sequence
        assert_equal(scaffold.layout.length, 1)
      end

      should "create sequence with reverse" do
        @assembly.first['sequence'].update('reverse' => true)
        mock(Scaffolder::Base::Sequence).new(@expect.update({:reverse => true }))
        scaffold = Scaffolder.new @assembly, @sequence
        assert_equal(scaffold.layout.length, 1)
      end

      should "throw an error when source doesn't have a matching sequence" do
        @assembly.first['sequence'].update('source' => 'sequence3')
        assert_raise(ArgumentError){ Scaffolder.new @assembly, @sequence }
      end
    end

    context "parsing an assembly with sequence inserts" do

      setup do
        @assembly.first['sequence'].update({"inserts" => [{
          "source" => "insert1", "start" => 5, "stop" => 10
        }]})
      end

      should "pass inserts to sequence object" do
        params = {:start => 5, :stop => 10, :sequence => 'GGTAGTA'}
        insert = Scaffolder::Base::Insert.new(params)

        mock.instance_of(Scaffolder::Base::Sequence).add_inserts([insert])
        mock(Scaffolder::Base::Insert).new(params){insert}

        scaffold = Scaffolder.new @assembly, @sequence
        assert_equal(scaffold.layout.length, 1)
      end

      should "throw and error when insert does not have a matching sequence" do
        @assembly.first['sequence']['inserts'].first.update({
          "source" => "missing"})
        assert_raise(ArgumentError){ Scaffolder.new @assembly, @sequence }
      end

    end

    context "when parsing an assembly with an unresolved region" do

      setup{ @assembly = [ {"unresolved" => { "length" => 5 } } ] }

      should 'create an unresolved region' do
        mock(Scaffolder::Base::Region).new(:unresolved,'N'*5)
        scaffold = Scaffolder.new @assembly, @sequence
        assert_equal(scaffold.layout.length, 1)
      end

    end

    context "when parsing an unknown tag" do
      setup{ @assembly = [{'non_standard_tag' => []}] }
      should "throw an argument error" do
        assert_raise(ArgumentError){ Scaffolder.new @assembly, @sequence }
      end
    end

  end
end
