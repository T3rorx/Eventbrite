
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :organized_events, class_name: "Event", foreign_key: :user_id, dependent: :restrict_with_exception
  has_many :attendances, dependent: :destroy
  has_many :events, through: :attendances
  validates :email, presence: true
  validates :encrypted_password, presence: true
  after_create :welcome_send
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable
  
  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end
end