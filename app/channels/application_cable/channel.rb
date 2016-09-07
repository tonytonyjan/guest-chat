module ApplicationCable
  class Channel < ActionCable::Channel::Base

    private

    def current_room
      @current_room ||= Room.find_by slug: params[:room]
    end
  end
end
