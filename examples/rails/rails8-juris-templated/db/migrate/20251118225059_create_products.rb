class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :sku, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :category
      t.boolean :active, default: true

      t.timestamps
    end
    
    add_index :products, :sku, unique: true
  end
end
