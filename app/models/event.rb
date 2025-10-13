class Event < ApplicationRecord
  belongs_to :organizer, class_name: "User", foreign_key: :user_id
  has_many :attendances, dependent: :destroy
  has_many :participants, through: :attendances, source: :user
end
