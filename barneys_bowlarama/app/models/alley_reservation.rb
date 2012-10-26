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
end
