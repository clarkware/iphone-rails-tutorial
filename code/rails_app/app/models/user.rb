# START:security
class User < ActiveRecord::Base

# END:security
  
  has_many :goals, :order => 'name', :dependent => :destroy
  
  attr_accessible :username, :email, :password, :password_confirmation
  attr_accessor :password
    
  validates_presence_of     :username, :email
  validates_uniqueness_of   :username, :email
  validates_format_of       :email, :with => /\A(\S+)@(\S+)\Z/, :allow_nil => true

  validates_presence_of :password, :on => :create
  validates_presence_of :password_confirmation, :on => :create
  
  validates_length_of   :password, :minimum => 6
  validates_confirmation_of :password
  
  before_save :encrypt_password
  
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    user = find_by_username(login) || find_by_email(login)
    (user && user.authenticated?(password)) ? user : nil        
  end
  
  def authenticated?(password)
    self.password_hash == User.encrypted_password(password, self.password_salt || "")
  end
  
  # Serialization, overridden for security!
  
  # START:security
  def to_xml(options={})
    default_serialization_options(options)
    super(options)
  end

  def to_json(options={})
    default_serialization_options(options)
    super(options)
  end
  
  def default_serialization_options(options={})
    options[:only] = [:username, :user_id, :updated_at, :created_at]
  end
  
  # END:security
  
private
  
  def self.secure_digest(*args)
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end
  
  def self.make_token
    secure_digest(Time.now, (1..10).map { rand.to_s })
  end
  
  def self.encrypted_password(password, salt)
    secure_digest(password, salt)
  end
  
  def encrypt_password
    return if self.password.blank?
    self.password_salt = User.make_token
    self.password_hash = User.encrypted_password(self.password, self.password_salt)
  end
  
# START:security
end
# END:security
