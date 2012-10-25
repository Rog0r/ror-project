class Holiday < ActiveRecord::Base
  attr_accessible :comment, :date

  validates :comment, :date, :presence => true
  validates :date, :uniqueness => true

  scope :coming, lambda {|date| where("date > ?", date)}
end
