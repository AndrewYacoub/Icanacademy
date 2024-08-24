class Group < ApplicationRecord
  include GoogleCalendarHelper
  belongs_to :course
  has_many :enrollments
  has_many :students, through: :enrollments, source: :user
  has_many :chat_messages
  has_many :sessions, dependent: :destroy
  has_many :homeworks, dependent: :destroy
  has_one :room, dependent: :destroy



  # Session times are now attributes of Group
  serialize :start_times, JSON
  serialize :end_times, JSON
  serialize :recurrence_days, JSON
  has_many :session_modifications, dependent: :destroy

  # You might still need to calculate occurrences based on recurrence_days,
  # but no need to create separate session records.
  def calculate_session_occurrences(day)
    schedule = IceCube::Schedule.new(self.start_date)
    schedule.add_recurrence_rule IceCube::Rule.weekly.day(day.downcase.to_sym).until(self.end_date)
    schedule.all_occurrences
  end
end
