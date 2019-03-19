class CreateDistributions < ActiveRecord::Migration[5.2]
  def change
    create_table :distributions do |t|
      t.string :name
      t.integer :user_id
      t.timestamps
    end
  end
end
