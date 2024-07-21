class ChangeStatusTypeInEnrollments < ActiveRecord::Migration[6.0]
  def up
    change_column :enrollments, :status, 'integer USING CAST(status AS integer)'
  end

  def down
    change_column :enrollments, :status, :string
  end
end
