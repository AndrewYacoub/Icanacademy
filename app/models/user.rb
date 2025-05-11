class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :enrollments
  has_many :groups, through: :enrollments
  has_many :messages
  after_create_commit { broadcast_append_to 'users' }
  has_one_attached :profile_picture_url

  has_many :messages, dependent: :destroy
  has_one :room

  # Payment associations
  has_many :payments, foreign_key: :student_id
  has_many :received_payments, class_name: 'Payment', foreign_key: :teacher_id
  
  validates :first_name, :last_name, presence: true

  # Stripe related fields
  validates :stripe_account_id, uniqueness: true, allow_nil: true
  validates :stripe_customer_id, uniqueness: true, allow_nil: true

  # Stripe account management
  def setup_stripe_customer
    return stripe_customer_id if stripe_customer_id.present?

    customer = Stripe::Customer.create(
      email: email,
      name: full_name,
      metadata: {
        user_id: id,
        user_type: type
      }
    )
    update(stripe_customer_id: customer.id)
    customer.id
  rescue Stripe::StripeError => e
    Rails.logger.error "Failed to create Stripe customer: #{e.message}"
    nil
  end

  def setup_stripe_express_account
    return stripe_account_id if stripe_account_id.present?
    return unless teacher?

    account = Stripe::Account.create(
      type: 'express',
      country: 'US',
      email: email,
      capabilities: {
        card_payments: { requested: true },
        transfers: { requested: true }
      },
      business_type: 'individual',
      business_profile: {
        name: full_name,
        url: Rails.application.routes.url_helpers.teacher_url(self)
      }
    )
    update(stripe_account_id: account.id)
    account.id
  rescue Stripe::StripeError => e
    Rails.logger.error "Failed to create Stripe account: #{e.message}"
    nil
  end

  def stripe_account_link(refresh_url:, return_url:)
    return unless stripe_account_id.present?

    Stripe::AccountLink.create(
      account: stripe_account_id,
      refresh_url: refresh_url,
      return_url: return_url,
      type: 'account_onboarding'
    )
  rescue Stripe::StripeError => e
    Rails.logger.error "Failed to create account link: #{e.message}"
    nil
  end

  def stripe_account_status
    return unless stripe_account_id.present?

    account = Stripe::Account.retrieve(stripe_account_id)
    {
      charges_enabled: account.charges_enabled,
      payouts_enabled: account.payouts_enabled,
      details_submitted: account.details_submitted,
      requirements: account.requirements
    }
  rescue Stripe::StripeError => e
    Rails.logger.error "Failed to retrieve account status: #{e.message}"
    nil
  end

  def can_receive_payments?
    return false unless teacher?
    return false unless stripe_account_id.present?

    status = stripe_account_status
    status && status[:charges_enabled] && status[:payouts_enabled]
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def student?
    type == 'Student'
  end

  def teacher?
    type == 'Teacher'
  end

  def update_last_seen
    self.update_column(:last_seen_at, Time.current)
  end

  def active?
    last_seen_at.present? && last_seen_at > 5.minutes.ago
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :education_level, :country, :address, :teaching, :profile_picture_url, :password, :password_confirmation)
  end
end
