class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.references :group, null: false, foreign_key: true
      t.string :google_meet_link

      t.timestamps
    end
  end
end
