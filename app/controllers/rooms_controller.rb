class RoomsController < ApplicationController
  def create
    redirect_to Room.create
  end

  def show
    @room = Room.find_by(slug: params[:id])
    @message = Message.new
  end
end
