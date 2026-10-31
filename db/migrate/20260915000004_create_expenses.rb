class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :menu_item, null: true, foreign_key: true
      t.string  :description, null: false
      t.integer :amount, null: false
      t.date    :spent_on, null: false
      t.timestamps
    end
    add_index :expenses, [:user_id, :spent_on]
    add_check_constraint :expenses, "amount > 0", name: "expenses_amount_positive"
  end
end
