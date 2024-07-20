class AddRecurringDetailsToSessions < ActiveRecord::Migration[7.1]
  def change
    add_column :sessions, :start_time, :datetime
    add_column :sessions, :end_time, :datetime
    add_column :sessions, :recurrence_days, :string
    add_column :sessions, :duration, :integer
  end
end
