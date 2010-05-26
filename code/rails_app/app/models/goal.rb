class Goal < ActiveRecord::Base
  
  belongs_to :user
  has_many :credits, :order => 'updated_at', :dependent => :destroy
  
  validates_presence_of :name, :amount
  validates_numericality_of :amount, :greater_than => 0.0

  def self.search(query)
    where("name like ?", "%#{query}%")
  end
  
  def saved
    credits.inject(0) {|sum, credit| sum + credit.amount }
  end
  
  def remaining
    amount - saved
  end
  
  def reached?
    saved >= amount
  end
  
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
    options[:only] = [:id, :name, :amount, :updated_at, :created_at]
    options[:methods] = [:saved, :remaining] if self.amount
  end
  
end
