class CreateFilters < ActiveRecord::Migration[5.2]
  def change
    create_table :filters do |t|
      t.string :fid
      t.string :filter_type
      t.string :parameter
      t.timestamps
    end
  end
end
