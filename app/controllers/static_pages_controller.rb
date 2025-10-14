class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: :secret

  def index
    # Récupère les 4 prochains événements (par date de début)
    @upcoming_events = Event.where("start_date >= ?", Time.now)
                            .order(start_date: :asc)
                            .limit(4)
  end

  def secret; end
end
