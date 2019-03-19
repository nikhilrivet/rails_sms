class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :phone
      t.string :sender
      t.string :message
      t.string :message_id
      t.string :message_status
      t.timestamp :donedate
      t.string :sub
      t.string :err
      t.integer :level
      t.string :text
      t.string :id_smsc
      t.string :dlvrd
      t.timestamp :subdate
      t.timestamps
    end
  end
end
