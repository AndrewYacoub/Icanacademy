class AddStripeFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :users, :stripe_account_id, :string
    add_column :users, :payout_enabled, :boolean, default: false

    add_index :users, :stripe_customer_id, unique: true
    add_index :users, :stripe_account_id, unique: true
  end
end
