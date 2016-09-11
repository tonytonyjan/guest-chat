# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{current_room.slug}"
    transmit_history
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    message = Message.create!(
      content: data['content'],
      guest: current_guest,
      room: current_room
    )
    broadcast_message message
  end

  private

  def transmit_history
    data = current_room.messages.order(:created_at).includes(:guest).map do |message|
      data_from_message(message)
    end
    transmit(data) unless data.empty?
  end

  def broadcast_message(message)
    ActionCable.server.broadcast("chat_#{current_room.slug}", data_from_message(message))
  end

  def data_from_message(message)
    adj, noun = message.guest.name.split(?的)
    {
      guest_id: message.guest.id,
      name: message.guest.name,
      avatar: message.guest.avatar,
      content: message.content,
      created_at: message.created_at,
      adj: adj,
      noun: noun
    }
  end
end
