class Alley < ActiveRecord::Base
  attr_accessible :number, :unlocked
  
  has_many :alley_reservations
  has_many :reservations, :through => :alley_reservations

  validates :number, :presence => true, :uniqueness => true
  validates :number, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }
  validates :unlocked, :inclusion => { :in => [true, false] }

  def unlocked? 
    self.unlocked  
  end
end
