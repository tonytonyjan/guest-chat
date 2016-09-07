# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class AppearChannel < ApplicationCable::Channel
  @guests = []

  class << self
    attr_reader :guests
  end

  def subscribed
    stream_from broadcasting_name
    transmit_online_guests
    self.class.guests << current_guest
  end

  def unsubscribed
    self.class.guests.delete current_guest
    broadcast_appearance({'on' => 'delete'})
  end

  def broadcast_appearance(data)
    context = data['on']
    unless context == 'create' || context == 'delete'
      raise ArgumentError, ':must be either :create or :delete'
    end

    message = {
      id: current_guest.id,
      avatar: current_guest.avatar,
      name: current_guest.name,
      action: context
    }

    ActionCable.server.broadcast(broadcasting_name, message)
  end

  private

  def broadcasting_name
    @broadcasting_name ||= "appear_#{current_room.slug}"
  end

  def transmit_online_guests
    data = self.class.guests.map do |guest|
      {
        id: guest.id,
        avatar: guest.avatar,
        name: guest.name
      }
    end

    transmit data unless data.empty?
  end
end
