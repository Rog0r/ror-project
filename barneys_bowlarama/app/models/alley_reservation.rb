class AlleyReservation < ActiveRecord::Base
  belongs_to :alley
  belongs_to :reservation
  attr_accessible :alley_id, :alley

  def occupied?
    @occupied ||= false
  end

  def set_occupied
    @occupied = true
  end

  def alley_number
    @alley_number
  end

  def set_alley_number number=-1
    @alley_number = number
  end
end
