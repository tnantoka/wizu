class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :root, alert: exception.message
  end

  private
    def set_wiki
      @wiki = Wiki.find_by!(slug: params[:wiki_id].presence || params[:id])
    end

    def page_params
      params.require(:page).permit(:title, :content, :parent_id)
    end
    
    # Locale
    def set_locale
      locale = available_locale(extract_locale_from_params)
      locale ||= available_locale(extract_locale_from_accept_language_header)
      locale ||= I18n.default_locale
      I18n.locale = locale
    end

    def extract_locale_from_accept_language_header
      request.env['HTTP_ACCEPT_LANGUAGE'].to_s.scan(/^[a-z]{2}/).first
    end

    def extract_locale_from_params
      params[:locale]
    end

    def available_locale(locale)
      locale.presence_in(I18n.available_locales.map(&:to_s))
    end

    def default_url_options(options = nil)
      if params[:locale].present?
        { locale: I18n.locale }
      else
        {}
      end
    end

    # Auth
    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
    helper_method :current_user

    def user_signed_in?
      !!current_user
    end
    helper_method :user_signed_in?

    def current_user=(user)
      @current_user = user
      session[:user_id] = user.try(:id)
    end

    def authenticate_user!
      redirect_to :root, alert: t('flash.application.unauthenticated') unless user_signed_in?
    end
end
