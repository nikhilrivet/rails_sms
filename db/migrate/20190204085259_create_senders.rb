class CreateSenders < ActiveRecord::Migration[5.2]
  def change
    create_table :senders do |t|
      t.string :name
      t.integer :user_id
      t.timestamps
    end
  end
end
