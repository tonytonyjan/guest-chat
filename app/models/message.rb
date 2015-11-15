class Message < ActiveRecord::Base
  default_scope { order('id ASC') }
  belongs_to :guest, touch: true
  belongs_to :room, touch: true
  after_create :pg_notify

  def pg_notify
    Message.connection.raw_connection.async_exec "NOTIFY message, '#{id}'"
  end
end
