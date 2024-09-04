class RemoveForeignKeyFromParticipants < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :participants, column: :user_id
  end
end
