class AddForeignKeyToParticipants < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :participants, :users, column: :user_id, on_delete: :cascade
  end
end
