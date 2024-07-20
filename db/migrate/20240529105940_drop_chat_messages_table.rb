class DropChatMessagesTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :chat_messages
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
