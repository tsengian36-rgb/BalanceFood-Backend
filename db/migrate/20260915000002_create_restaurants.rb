class CreateRestaurants < ActiveRecord::Migration[7.1]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.string :category
      t.string :address
      t.text   :description
      t.timestamps
    end
    add_index :restaurants, :name
    add_index :restaurants, :category
  end
end
