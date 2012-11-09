# encoding: UTF-8

class OfficeHour < ActiveRecord::Base
  attr_accessible :day, :open_from, :open_to

  validates :day, :open_from, :open_to, :presence => true
  validate :valid_time?
  def self.by_date(date)
    find(:first, :conditions => {:day => date.strftime("%A")})
  end

  def valid_time?
    errors.add(:base, "Ungültiger Zeitraum gewählt (von >= bis)") if (open_to - 1.hour) < open_from
  end

  def too_early?(time)
    time.strftime("%H%M") < open_from.strftime("%H%M")
  end

  def is_open?(from, to = from + 1.hour)
    open_from.strftime("%H%M") <= from.strftime("%H%M") \
      && from.strftime("%H%M") < open_to.strftime("%H%M") \
      && open_from.strftime("%H%M") < to.strftime("%H%M") \
      && to.strftime("%H%M") <= open_to.strftime("%H%M")
  end

end
