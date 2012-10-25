class CreateTableAlleysReservations < ActiveRecord::Migration
  def change
    create_table :alleys_reservations do |t|
      t.integer :alley_id, :null => false
      t.integer :reservation_id, :null => false
    end
   end

 end
