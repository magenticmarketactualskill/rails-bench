class CreateProductExports < ActiveRecord::Migration[8.1]
  def change
    create_table :product_exports do |t|
      t.integer :product_id, null: false
      t.string :name, null: false
      t.string :sku, null: false
      t.integer :price_cents, null: false
      t.string :category_slug
      t.datetime :exported_at, null: false

      t.timestamps
    end
    
    add_index :product_exports, :product_id
  end
end
