class AddSmsCountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :sms_count, :integer
  end
end
