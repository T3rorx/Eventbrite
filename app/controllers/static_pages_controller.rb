class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: :secret

  def index
    # Récupère les 4 prochains événements (par date de début) avec les attendances
    @upcoming_events = Event.where("start_date >= ?", Time.now)
                            .includes(:attendances)
                            .order(start_date: :asc)
                            .limit(4)
    
    # Statistiques réelles pour la page d'accueil
    @total_events = Event.count
    @total_organizers = User.joins(:organized_events).distinct.count
    @total_attendances = Attendance.count
    @total_participants = User.joins(:attendances).distinct.count
  end

  def secret; end
end
