class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :enrollments
  has_many :groups, through: :enrollments
  has_many :messages
  after_create_commit { broadcast_append_to 'users' }
  
  has_many :messages, dependent: :destroy
  has_one :room  
  def student?
    type == 'Student'
  end

  def teacher?
    type == 'Teacher'
  end
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :education_level, :country, :address, :teaching, :password, :password_confirmation)
  end
end
