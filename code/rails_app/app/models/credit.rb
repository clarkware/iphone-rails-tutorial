class Credit < ActiveRecord::Base
  belongs_to :goal
  
  validates_presence_of :name, :amount
  validates_numericality_of :amount, :greater_than => 0
  
  def to_xml(options={})
    default_serialization_options(options)
    super(options)
  end
  
  def to_json(options={})
    default_serialization_options(options)
    super(options)
  end
  
protected

  def default_serialization_options(options={})
    options[:only] = [:id, :name, :goal_id, :amount, :updated_at, :created_at]
  end
  
end

