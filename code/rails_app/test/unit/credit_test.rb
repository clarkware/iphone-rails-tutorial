require 'test_helper'

class CreditTest < ActiveSupport::TestCase
        
  setup do
    @valid_attributes = { 
      :name   => "Latte",
      :amount => 5.0
    }
    
    @credit = Credit.new(@valid_attributes)
  end
  
  test "create with valid attributes should save record" do
    assert_difference 'Credit.count', 1 do
      record = Credit.create(@valid_attributes)
      assert !record.new_record?
    end
  end
  
  test "should require name" do
    @credit.name = nil
    assert !@credit.valid?
    assert @credit.errors[:name].any?

    @credit.name = "The Credit"
    assert @credit.valid?, @credit.errors.full_messages
  end
  
  test "should require amount" do
    @credit.amount = nil
    assert !@credit.valid?
    assert @credit.errors[:amount].any?

    @credit.amount = 10.0
    assert @credit.valid?, @credit.errors.full_messages
  end
  
  test "should have positive amount" do
    @credit.amount = 0.0
    assert !@credit.valid?
    assert @credit.errors[:amount].any?
    
    @credit.amount = -1.0
    assert !@credit.valid?
    assert @credit.errors[:amount].any?
  end
  
  test "serialize should contain goal id" do
    xml  = Hash.from_xml(credits(:latte).to_xml)["credit"]
    json = ActiveSupport::JSON.decode(credits(:latte).to_json)["credit"]
    [xml, json].each do |result|
      assert_equal goals(:ipad).id, result["goal_id"]
    end
  end

end