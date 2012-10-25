class CreateOfficeHours < ActiveRecord::Migration
  def change
    create_table :office_hours do |t|
      t.string :day
      t.time :open_from
      t.time :open_to

      t.timestamps
    end

    %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday).each do |d|
      OfficeHour.create :day => d, :open_from => Time.gm(2000,1,1,12,30), :open_to => Time.gm(2000,1,1,23)
    end
  end
end
