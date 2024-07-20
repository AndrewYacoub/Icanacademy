class ChangeStatusTypeInEnrollments < ActiveRecord::Migration[6.0]
  def up
    change_column :enrollments, :status, :integer
  end

  def down
    change_column :enrollments, :status, :string
  end
end