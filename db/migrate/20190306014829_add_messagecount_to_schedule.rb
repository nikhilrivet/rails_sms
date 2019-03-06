class AddMessagecountToSchedule < ActiveRecord::Migration[5.2]
  def change
    add_column :schedules, :message_count, :integer
  end
end
