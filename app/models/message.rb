class Message < ApplicationRecord
  belongs_to :guest, touch: true
  belongs_to :room, touch: true
  after_commit :broadcast, on: :create

  private

  def broadcast
    message = {
      name: guest.name,
      avatar: guest.avatar,
      content: content,
      created_at: created_at
    }
    ActionCable.server.broadcast("chat_#{room.slug}", message)
  end
end
