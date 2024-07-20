class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.string :title
      t.text :description
      t.bigint :teacher_id

      t.timestamps
    end
    add_foreign_key :courses, :users, column: :teacher_id
  end
end

