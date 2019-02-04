class AddMessageStatusToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :message_send_status, :integer
  end
end
