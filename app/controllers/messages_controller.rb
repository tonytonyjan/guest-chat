class MessagesController < ApplicationController
  before_action :set_room
  def index
    @messages = if last_message = @room.messages.find_by(id: params[:last_read_message_id])
       @room.messages.where('id > ?', last_message.id)
    else
       @room.messages
    end
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
