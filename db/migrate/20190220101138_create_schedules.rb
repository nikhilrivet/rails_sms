class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.integer :user_id
      t.string :phone
      t.string :sender
      t.string :message
      t.string :batch_id
      t.string :message_status
      t.timestamp :schedule_time
      t.timestamps
    end
  end
end
