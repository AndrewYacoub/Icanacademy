class CreateSessionModifications < ActiveRecord::Migration[6.0]
  def change
    create_table :session_modifications do |t|
      t.references :group, null: false, foreign_key: true
      t.date :date
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end