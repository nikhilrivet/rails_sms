class CreateRouters < ActiveRecord::Migration[5.2]
  def change
    create_table :routers do |t|
      t.string :router_order
      t.string :router_type
      t.float :rate
      t.string :connector
      t.string :filter
      t.timestamps
    end
  end
end
