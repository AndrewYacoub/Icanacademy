class Payment < ApplicationRecord
  belongs_to :student, class_name: 'User'
  belongs_to :teacher, class_name: 'User'
  belongs_to :course

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true

  monetize :amount_cents

  before_create :calculate_shares

  enum status: {
    pending: 'pending',
    processing: 'processing',
    completed: 'completed',
    failed: 'failed'
  }

  def teacher_amount
    (amount * 0.75).round(2)
  end

  def platform_amount
    (amount * 0.25).round(2)
  end

  private

  def calculate_shares
    self.teacher_share = teacher_amount
    self.platform_share = platform_amount
  end
end
