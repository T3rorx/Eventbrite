class AttendanceMailer < ApplicationMailer
    def inscription_attendance(attendance)
    @attendance = attendance

    @user = @attendance.user

    # c'est cet appel à mail() qui permet d'envoyer l’e-mail en définissant destinataire et sujet.
    mail(to: @user.email, subject: 'Inscription evenement !') 
  end
end