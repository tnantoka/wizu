class WelcomeController < ApplicationController
  before_action :authenticate_user!, except: %i(index)

  def index
    redirect_to :dashboard and return if user_signed_in?
  end

  def dashboard
    @wikis = current_user.wikis.recent
    @wikis << Wiki.new if @wikis.exists?
  end
end
