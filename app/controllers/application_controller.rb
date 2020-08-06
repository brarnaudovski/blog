class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :require_login
  around_action :switch_locale

  private

  def require_login
    unless logged_in?
      flash[:danger] = 'Please sign in to continue.'
      redirect_to login_path
    end
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
