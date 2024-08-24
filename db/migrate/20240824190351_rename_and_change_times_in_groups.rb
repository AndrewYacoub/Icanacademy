class RenameAndChangeTimesInGroups < ActiveRecord::Migration[7.1]
  def change
    def change
      # Rename columns first
      rename_column :groups, :start_time, :start_times
      rename_column :groups, :end_time, :end_times
  
      # Change column types from time to text
      change_column :groups, :start_times, :text
      change_column :groups, :end_times, :text
    end
  end
end
