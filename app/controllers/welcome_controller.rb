class WelcomeController < ApplicationController
  before_action :authenticate_user!, except: %i(index)

  def index
    redirect_to :dashboard and return if user_signed_in?
  end

  def dashboard
  end
end
