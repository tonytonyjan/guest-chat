class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_guest
    @guest ||= (
      guest = Guest.find_or_create_by!(id: session[:guest_id])
      session[:guest_id] = guest.id
      guest
    )
  end

  helper_method :current_guest
end
