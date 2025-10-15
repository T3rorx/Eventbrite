class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event
  
  attr_accessor :skip_inscription_send
  after_create :inscription_send, unless: :skip_inscription_send

  def inscription_send
    AttendanceMailer.inscription_attendance(self).deliver_now
  end
end