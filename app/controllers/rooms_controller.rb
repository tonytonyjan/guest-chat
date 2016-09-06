class RoomsController < ApplicationController
  def create
    redirect_to Room.create
  end

  def show
    @room = Room.includes(messages: :guest).find_or_create_by slug: params[:id]
    @guests = Guest.limit(3)
    @messages = @room.messages
  end
end
