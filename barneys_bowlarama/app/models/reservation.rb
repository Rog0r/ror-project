class Reservation < ActiveRecord::Base
  belongs_to :user
  has_many :alley_reservations
  has_many :alleys, :through => :alley_reservations

  accepts_nested_attributes_for :alley_reservations, 
    :allow_destroy => true, 
    :reject_if => :all_blank

  attr_accessible :date, :start_time, :end_time, :alley_reservations_attributes

  validates :date, :start_time, :end_time, :user_id, :presence => true
  validate :valid_time?, :in_office_hours?, :has_conflicts?, :check_alleys

  def valid_time?
    errors.add(:end_time, "must be at least 1 hour later than start time") if (start_time + 1.hour) > end_time
  end

  def in_office_hours?
    errors[:base] << "Reservation time is not in office hours" unless OfficeHour.by_date(date).is_open? start_time, end_time
  end

  def has_conflicts?
    self.alleys.each do |alley|
      alley.reservations.by_date(self.date).each do |reservation|
        if reservation.in_conflict? self.start_time, self.end_time
          errors[:base] << "Reservation is in conflict with another reservation"
          return
        end 
      end 
    end
  end

  def check_alleys
    if self.alley_reservations.size < 1 || self.alley_reservations.all?{|ar| ar.marked_for_destruction? }
      errors[:base] << "There must be at least one alley present"
    end
  end


  def in_conflict?(from, to = from + 1.hour)
    (start_time.strftime("%H%M") <= from.strftime("%H%M") \
     && from.strftime("%H%M") <= end_time.strftime("%H%M")) \
     || (start_time.strftime("%H%M") < to.strftime("%H%M") \
         && to.strftime("%H%M") <= end_time.strftime("%H%M")) 
  end

  scope :by_date, lambda{ |date| where('date = ?', date).order("start_time ASC") }
end
