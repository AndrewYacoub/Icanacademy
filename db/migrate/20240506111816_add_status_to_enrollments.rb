class AddStatusToEnrollments < ActiveRecord::Migration[7.1]
  def change
    add_column :enrollments, :status, :string
  end
end
