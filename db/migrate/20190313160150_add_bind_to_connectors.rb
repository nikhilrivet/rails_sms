class AddBindToConnectors < ActiveRecord::Migration[5.2]
  def change
    add_column :connectors, :bind, :string
    add_column :connectors, :bind_to, :integer
    add_column :connectors, :src_ton, :integer
    add_column :connectors, :src_npi, :integer
  end
end
