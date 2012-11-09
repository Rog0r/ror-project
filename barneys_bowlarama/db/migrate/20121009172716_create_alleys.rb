class CreateAlleys < ActiveRecord::Migration
  def change
    create_table :alleys do |t|
      t.integer :number

      t.timestamps
    end

    (1..8).each do |i|
      Alley.create :number => i
    end
  end
end
