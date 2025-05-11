class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :student, null: false, foreign_key: { to_table: :users }
      t.references :teacher, null: false, foreign_key: { to_table: :users }
      t.references :course, null: false, foreign_key: true
      t.monetize :amount
      t.decimal :teacher_share, precision: 10, scale: 2
      t.decimal :platform_share, precision: 10, scale: 2
      t.string :status, default: 'pending'
      t.string :stripe_payment_id
      t.string :stripe_transfer_id
      t.text :error_message

      t.timestamps
    end

    add_index :payments, :status
    add_index :payments, :stripe_payment_id
    add_index :payments, :stripe_transfer_id
  end
end
