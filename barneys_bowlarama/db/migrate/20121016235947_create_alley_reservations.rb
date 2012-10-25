class CreateAlleyReservations < ActiveRecord::Migration
  def change
    create_table :alley_reservations do |t|
      t.references :alley
      t.references :reservation

      t.timestamps
    end
    add_index :alley_reservations, :alley_id
    add_index :alley_reservations, :reservation_id
  end
end
