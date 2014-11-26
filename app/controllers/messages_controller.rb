class MessagesController < ApplicationController
  before_action :set_room
  def index
    if @room.messages.exists?(params[:last_read_message_id])
      @messages = @room.messages.where('id > ?', params[:last_read_message_id])
    else
      @messages = @room.messages
    end
    render layout: nil
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
