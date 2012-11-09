class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :remember_me, :role, :first_name, :last_name, :phone, :bonus_count, :password, :password_confirmation

  validates :email, :role, :first_name, :last_name, :phone, :presence => true
  validates :role, :inclusion => { :in => %w(guest user cashier admin),
                                   :message => "%{value} is not a valid role" }
  # attr_accessible :title, :body

  has_many :reservations

  def admin?
    self.role == "admin"
  end

  def cashier?
    self.role == "cashier"
  end

  def user?
    self.role == "user"
  end

  def full_name
   " #{self.first_name} #{self.last_name}"
  end
end
