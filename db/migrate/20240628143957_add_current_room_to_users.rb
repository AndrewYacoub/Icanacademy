class AddCurrentRoomToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :room, foreign_key: true
  end
end