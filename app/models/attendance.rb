class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event
  after_create :inscription_send

  def inscription_send
    AttendanceMailer.inscription_attendance(self).deliver_now
  end
end