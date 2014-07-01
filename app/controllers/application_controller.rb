class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_guest
    @guest ||= Guest.find_by(id: session[:guest_id]) || Guest.create.tap{ |guest| session[:guest_id] = guest.id }
  end

  helper_method :current_guest
end
