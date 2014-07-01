class MessagesController < ApplicationController
  before_action :set_room
  def index
    @messages = @room.messages.where.not(id: params[:read_message_ids])
  end

  def create
    @message = current_guest.messages.new params.require(:message).permit(:content)
    @message.room = @room
    if @message.save
      render json: @message
    else
      head :bad_request
    end
  end

  def set_room
    @room = Room.find_by(slug: params[:room_id])
  end
end
