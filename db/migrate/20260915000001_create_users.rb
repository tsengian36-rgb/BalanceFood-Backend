class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string  :name, null: false
      t.string  :email, null: false
      t.string  :password_digest, null: false
      t.integer :current_balance, null: false, default: 0 # saldo JUNAEB en pesos CLP
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_check_constraint :users, "current_balance >= 0", name: "users_balance_non_negative"
  end
end
