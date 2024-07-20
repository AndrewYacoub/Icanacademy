class AddParentDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :parent_phone_number, :string
  end
end
