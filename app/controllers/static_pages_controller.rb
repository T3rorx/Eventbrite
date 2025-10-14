class StaticPagesController < ApplicationController
  def index
  end

  def secret
    before_action :authenticate_user!, only: [:secret]
  end
end
