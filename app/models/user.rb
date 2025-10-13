
class User < ApplicationRecord
  has_many :organized_events, class_name: "Event", foreign_key: :user_id, dependent: :restrict_with_exception
  has_many :attendances, dependent: :destroy
  has_many :events, through: :attendances
validates :email, presence: true
validates :encrypted_password, presence: true
end