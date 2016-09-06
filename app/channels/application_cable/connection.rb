module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_guest

    def connect
      self.current_guest = find_verified_guest
    end

    protected

    def find_verified_guest
      guest = Guest.find_or_create_by!(id: cookies.signed[:guest_id])
      cookies.signed[:guest_id] = guest.id
      guest
    end
  end
end
