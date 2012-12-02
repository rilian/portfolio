class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_cache_buster

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

private
  def set_cache_buster
    return unless Rails.env.development?
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
