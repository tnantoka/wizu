class WelcomeController < ApplicationController
  before_action :authenticate_user!, except: %i(index redirect)

  def index
    redirect_to :dashboard and return if user_signed_in?
  end

  def dashboard
    @wikis = current_user.accessible_wikis.recent
    @wikis << Wiki.new if @wikis.exists?
  end

  def redirect
    raise ActiveRecord::RecordNotFound unless request.referer.to_s =~ /\A#{Regexp.escape(root_url)}/
    redirect_to CGI.unescape(params[:u])
  end
end
