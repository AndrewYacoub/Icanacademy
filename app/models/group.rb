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
  validates :start_time, :end_time, presence: true
  serialize :recurrence_days, JSON
  has_many :session_modifications, dependent: :destroy

  # You might still need to calculate occurrences based on recurrence_days,
  # but no need to create separate session records.
  def calculate_session_occurrences
    schedule = IceCube::Schedule.new(self.start_date)
    recurrence_days.each do |day|
      schedule.add_recurrence_rule IceCube::Rule.weekly.day(day.downcase.to_sym).until(self.end_date)
    end
    schedule.all_occurrences
  end
end
