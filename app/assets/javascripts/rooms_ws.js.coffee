if WebSocket
  $(document).on 'page:change', () ->
    websocket = null
    token = $('#current_guest').data('token')
    start = () ->
      websocket = new WebSocket('ws://' + document.location.hostname + ':9527/' + $('#room').data('slug'));
      websocket.onclose = () ->
        setTimeout start, 5000 # reconnect in 5 seconds
      websocket.onopen = () ->
        websocket.send JSON.stringify op: 'sign_in', last_read: $('.message:last-child').data('message-id'), token: token
      websocket.onmessage = (event) ->
        data = JSON.parse event.data
        switch data.op
          when 'ok' then $("#message_content").val('')
          when 'error' then alert('出錯了')
          when 'messages'
            scroll_flag = false
            is_btm = $('#messages').height() + $('#messages').scrollTop() >= $('#messages')[0].scrollHeight - 10
            for message in data.messages
              scroll_flag = true
              color = if message.guest.id == $('#current_guest').data('id') then 'warning' else 'primary'
              $('#messages').append('<div class="row message" data-message-id="'+message.id+'"> <div class="col-sm-2"> <span class="name label label-'+color+'">'+message.guest.name+'</span> </div> <div class="col-sm-10">'+message.content+'</div> </div>')
              code_block = $('[data-message-id="'+message.id+'"] pre code')[0]
              hljs.highlightBlock code_block if code_block
            $('#messages').scrollTop($('#messages')[0].scrollHeight) if scroll_flag && is_btm
          when 'message'
            is_btm = $('#messages').height() + $('#messages').scrollTop() >= $('#messages')[0].scrollHeight - 10
            message = data
            color = if message.guest.id == $('#current_guest').data('id') then 'warning' else 'primary'
            $('#messages').append('<div class="row message" data-message-id="'+message.id+'"> <div class="col-sm-2"> <span class="name label label-'+color+'">'+message.guest.name+'</span> </div> <div class="col-sm-10">'+message.content+'</div> </div>')
            code_block = $('[data-message-id="'+message.id+'"] pre code')[0]
            hljs.highlightBlock code_block if code_block
            $('#messages').scrollTop($('#messages')[0].scrollHeight) if is_btm
    start()
    $("#message_content").keypress (e) ->
      websocket.send(JSON.stringify(op: 'messages:create', content: this.value, token: token)) if e.which == 13 && !e.shiftKey && $('#message_content').val().trim().length > 0
    .focus()