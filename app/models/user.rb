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

  # validates :profile_picture_url, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 5.megabytes }

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
