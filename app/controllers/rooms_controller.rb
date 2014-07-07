class RoomsController < ApplicationController
  def create
    redirect_to Room.create
  end

  def show
    @room = Room.find_or_create_by slug: params[:id]
    @message = Message.new
    verifier = Rails.application.message_verifier Rails.application.secrets.secret_key_base
    @token = verifier.generate current_guest.id
  end
end
