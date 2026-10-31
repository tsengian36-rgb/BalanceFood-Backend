class CreateMenuItems < ActiveRecord::Migration[7.1]
  def change
    create_table :menu_items do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.string  :name, null: false
      t.text    :description
      t.integer :price, null: false # pesos CLP
      t.string  :category
      t.boolean :available, null: false, default: true
      t.timestamps
    end
    add_index :menu_items, :price
    add_check_constraint :menu_items, "price > 0", name: "menu_items_price_positive"
  end
end
