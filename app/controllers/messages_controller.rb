class MessagesController < ApplicationController
  before_action :set_room
  before_action :exec_command, only: :create
  def index
    if @room.messages.exists?(params[:last_read_message_id])
      @messages = @room.messages.where('id > ?', params[:last_read_message_id])
    else
      @messages = @room.messages
    end
    @messages = @messages.includes(:guest)
    render layout: nil
  end

  def create
    @message = current_guest.messages.new message_params
    @message.room = @room
    if @message.save
      render json: @message
    else
      head :bad_request
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def set_room
    @room = Room.find_by(slug: params[:room_id])
  end

  def exec_command
    command = message_params[:content].presence
    if command && command.start_with?('/'.freeze)
      command.slice!(0)
      msg = current_guest.exec(command) ? :指令成功 : :指令失敗
      render json: {msg: msg}
    end
  end
end
