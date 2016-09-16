class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  force_ssl

  def current_guest
    @guest ||= (
      guest = Guest.find_or_create_by!(id: cookies.signed[:guest_id])
      cookies.signed[:guest_id] = guest.id
      guest
    )
  end

  helper_method :current_guest
end
