# app/helpers/form_helper
module FormHelper
  def setup_reservation(reservation)
    reservation.alley_reservations.uniq!
    (Alley.all - reservation.alleys).each do |alley|
      reservation.alley_reservations.build(:alley => alley)
    end
    reservation.alley_reservations.sort_by! {|x| x.alley.id }
    reservation
  end
end

