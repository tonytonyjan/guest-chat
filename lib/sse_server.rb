require 'eventmachine'
require 'logger'

DB_CONN = ActiveRecord::Base.connection_pool.checkout.raw_connection
DB_SOCKET = DB_CONN.socket_io
LOGGER = Logger.new(ENV['LOG_PATH'] || STDOUT)
ERROR_LOGGER = Logger.new(ENV['ERROR_LOG_PATH'] || STDERR)

DB_CONN.exec 'LISTEN message'

class PushServer < EM::Connection
  @@rooms_map_clients = {}

  def post_init
    LOGGER.info "#{self} connected"
  end

  def notify_readable
    DB_CONN.consume_input
    while notification = DB_CONN.notifies
      event, pid, payload = notification[:relname], notification[:be_pid], notification[:extra]
      DB_CONN.async_exec "SELECT messages.room_id, guests.name, guests.role, messages.content FROM messages INNER JOIN guests ON (guests.id = guest_id) WHERE messages.id = #{ActiveRecord::Base.connection.quote notification[:extra]}" do |result|
        room_id, name, role, content = result.values.first
        broadcast room_id, {name: name, role: role, content: content} 
      end
    end
  end

  def broadcast room_id, message
    Array(@@rooms_map_clients[room_id]).each do |client|
      client.send_data "data: #{message.to_json}\n\n"
    end
  end

  def receive_data data
    if data =~ %r{GET /(\w+) HTTP/1.1}
      DB_CONN.async_exec "SELECT id, slug FROM rooms WHERE slug = #{ActiveRecord::Base.connection.quote $1}" do |result|
        if result.count > 0
          room_id = result.values.first.first
          @@rooms_map_clients[room_id] ||= []
          @@rooms_map_clients[room_id] << self
          send_data "HTTP/1.1 200 OK
Server: SSE Server by tonytonyjan
Content-Type: text/event-stream
Connection: keep-alive
Access-Control-Allow-Origin: *\n\n"
        else
          close
        end
      end
    else
      close
    end
  end

  def unbind
    if @@rooms_map_clients[@room_id]
      @@rooms_map_clients[@room_id].delete(self)
      @@rooms_map_clients.delete(@room_id) if @@rooms_map_clients[@room_id].empty?
    end
    LOGGER.info "#{self} disconnected"
  end

  def close
    send_data "HTTP/1.1 404 Not Found\nServer: SSE Server by tonytonyjan\n\n"
    close_connection_after_writing
  end
end

argv = ARGV.presence || %w[0.0.0.0 3310]

EM.epoll
EventMachine.run do
  conn = EventMachine.watch DB_SOCKET, PushServer
  conn.notify_readable = true
  EventMachine.start_server *argv, PushServer
  File.chmod(0777, argv.first) if argv.length == 1
end