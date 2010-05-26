require 'test_helper'

class GoalTest < ActiveSupport::TestCase
        
  setup do
    @valid_attributes = { 
      :name   => "iPad",
      :amount => 500.0
    }
    
    @goal = Goal.new(@valid_attributes)
    
    @one_credit   = Credit.new(:name => "one",  :amount => 1.00)
    @two_credits  = Credit.new(:name => "two",  :amount => 2.00)
    @four_credits = Credit.new(:name => "four", :amount => 4.00)
  end
  
  test "create with valid attributes should save record" do
    assert_difference 'Goal.count', 1 do
      record = Goal.create(@valid_attributes)
      assert !record.new_record?
    end
  end
  
  test "should require name" do
    @goal.name = nil
    assert !@goal.valid?
    assert @goal.errors[:name].any?

    @goal.name = "The Goal"
    assert @goal.valid?, @goal.errors.full_messages
  end
  
  test "should require amount" do
    @goal.amount = nil
    assert !@goal.valid?
    assert @goal.errors[:amount].any?

    @goal.amount = 10.0
    assert @goal.valid?, @goal.errors.full_messages
  end
  
  test "should have positive amount" do
    @goal.amount = 0.0
    assert !@goal.valid?
    assert @goal.errors[:amount].any?
    
    @goal.amount = -1.0
    assert !@goal.valid?
    assert @goal.errors[:amount].any?
  end
  
  test "saved should accumulate credit ammounts" do
    @goal.amount = 5.00
    assert_equal 0.0, @goal.saved
    
    @goal.credits << @one_credit
    assert_equal 1.0, @goal.saved
    
    @goal.credits << @two_credits
    assert_equal 3.0, @goal.saved
  end
  
  test "reached should be saved at least the amount" do
    @goal.amount = 5.00
    assert !@goal.reached?
    
    @goal.credits << @one_credit
    assert !@goal.reached?
    
    @goal.credits << @four_credits
    assert @goal.reached?
  end
  
  test "remaining should be amount less saved" do
    @goal.amount = 5.00
    
    assert_equal 5.00, @goal.remaining
    
    @goal.credits << @one_credit
    assert_equal 4.00, @goal.remaining
    
    @goal.credits << @four_credits
    assert_equal 0.00, @goal.remaining
    
    @goal.credits << @two_credits
    assert_equal -2.00, @goal.remaining
  end
  
  test "serialize should contain method results" do
    xml  = Hash.from_xml(@goal.to_xml)["goal"]
    json = ActiveSupport::JSON.decode(@goal.to_json)["goal"]
    [xml, json].each do |result|
      assert_not_nil result["saved"]
      assert_not_nil result["remaining"]
    end
  end

end
