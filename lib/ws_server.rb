require 'em-websocket'
EM.run do
  # instance variables share with each connections
  @verifier = Rails.application.message_verifier(Rails.application.secrets.secret_key_base)
  @channels = {}
  EM::WebSocket.run(host: '0.0.0.0', port: 9527) do |ws|
    ws.onopen do |handshake|
      room = Room.find_by! slug: handshake.path.sub('/', '')
      guest = Guest.find(@verifier.verify handshake.query_string)
      @channels[room.slug] ||= EM::Channel.new
      channel = @channels[room.slug]
      sid = channel.subscribe { |msg| ws.send msg } # for unsubscribing while closing
      ws.onmessage do |msg|
        begin
          params = JSON msg
          case params['op']
          when 'messages'
            messages = room.messages.where('id > ?', params['last_read'].to_i)
            result = Jbuilder.encode do |json|
              json.op :messages
              json.messages do
                json.array!(messages) do |message|
                  json.extract! message, :id
                  json.content RDiscount.new(message.content, :autolink).to_html
                  json.guest do
                    json.extract! message.guest, :id, :name
                  end
                end
              end
            end # Jbuilder.encode do
            ws.send result
          when 'messages:create'
            message = guest.messages.new content: params['content'], room: room
            ws.send({op: (message.save ? :ok : :error)}.to_json)
            channel.push({op: :message, id: message.id, content: RDiscount.new(message.content, :autolink).to_html, guest: {id: guest.id, name: guest.name}}.to_json)
          end
        rescue
          puts $!.inspect, $@
        end
      end

      ws.onclose do
        channel.unsubscribe(sid)
        @channels.delete(room.slug) if channel.instance_variable_get(:@subs).empty?
      end
    end # ws.onopen
  end # EM::WebSocket.run
  puts 'Server started'
end # EM.run do