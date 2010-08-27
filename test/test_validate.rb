require 'helper'

class TestInsert < Test::Unit::TestCase
  context Scaffolder::Validate do

    context "two overlapping inserts" do
      should "not be a valid assembly"
      should "be highlighted as overlapping inserts"
    end

    context "two non overlapping inserts" do
      should "be a valid assembly"
    end

    context "an insert with a sequence identity below a threshold" do
      should "not be a valid assembly"
      should "be highlighted as a miss matching insert"
    end

    context "an insert with a sequence identity above a threshold" do
      should "be a valid assembly"
    end

  end
end
