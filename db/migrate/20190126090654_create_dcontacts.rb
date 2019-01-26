class CreateDcontacts < ActiveRecord::Migration[5.2]
  def change
    create_table :dcontacts do |t|
      t.string :number
      t.integer :distribution_id
      t.timestamps
    end
  end
end
