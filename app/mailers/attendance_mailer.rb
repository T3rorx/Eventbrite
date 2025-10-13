class AttendanceMailer < ApplicationMailer
  def inscription_attendance(attendance)
    @attendance = attendance
    @event = @attendance.event
    @user = @attendance.user
    @organizer = @event.user
    @event_start = @event.start_date&.strftime("%d/%m/%Y à %Hh%M")
    @url = "https://www.grenoble-roller.org/espace-adherent"

    mail(to: @user.email, subject: "Grenoble Roller - Ta place est réservée pour #{@event.title}")
  end
end
