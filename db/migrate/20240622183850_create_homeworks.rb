class CreateHomeworks < ActiveRecord::Migration[7.1]
  def change
    create_table :homeworks do |t|
      t.string :title
      t.string :lesson
      t.text :description
      t.string :link
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
