class CreateDrafts < ActiveRecord::Migration[5.2]
  def change
    create_table :drafts do |t|
      t.string :draft_content
      t.integer :user_id
      t.timestamps
    end
  end
end
