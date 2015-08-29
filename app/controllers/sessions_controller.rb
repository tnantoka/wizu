class SessionsController < ApplicationController
  before_action :authenticate_user!, except: %i(create failure)

  def create
    auth_hash = request.env['omniauth.auth']
    ActiveRecord::Base.transaction do
      identity = Identity.find_or_create_with_auth_hash!(auth_hash) 
      user = User.find_or_create_with_identity!(identity)
      self.current_user = user
      redirect_to :dashboard, notice: t('flash.sessions.signed_in')
    end
  end

  def destroy
    self.current_user = nil
    redirect_to :root, notice: t('flash.sessions.signed_out')
  end

  def failure
    redirect_to :root, alert: t('flash.sessions.failed')
  end
end
