class CreateConnectors < ActiveRecord::Migration[5.2]
  def change
    create_table :connectors do |t|
      t.string :cid
      t.string :host
      t.string :port
      t.string :session
      t.string :username
      t.string :password
      t.string :status
      t.integer :option
      t.timestamps
    end
  end
end
