require 'active_record/fixtures'

class LoadsHolidays < ActiveRecord::Migration
  def up
    down()

    directory = File.join(File.dirname(__FILE__), "init_data")
    ActiveRecord::Fixtures.create_fixtures(directory, "holidays")
  end

  def down
    Holiday.delete_all
  end
end
