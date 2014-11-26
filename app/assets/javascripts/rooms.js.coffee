$(document).on 'page:change', () ->
  # send message
  $('#new_message')
    .on 'ajax:success', (event, message) -> $('#message_content').val('')
    .on 'ajax:error', () -> alert('出錯了')
    .on 'ajax:complete', () -> $('#message_content').attr('disabled', false)
  $("#message_content")
    .keypress (e) ->
      if e.which == 13 && !e.shiftKey && $('#message_content').val().trim().length > 0
        e.preventDefault()
        $(this.form).submit()
        this.disabled = true
    .focus()
  pull_messages = () ->
    $.get '/rooms/' + $('#room').data('slug') + '/messages.json', last_read_message_id: $('.message:last-child').data('message-id')
    .done (messages) ->
      scroll_flag = false
      is_btm = $('#messages').height() + $('#messages').scrollTop() >= $('#messages')[0].scrollHeight - 10
      for message in messages
        scroll_flag = true
        color = if message.guest.id == $('#current_guest').data('id') then 'warning' else 'primary'
        $('#messages').append('<div class="row message" data-message-id="'+message.id+'"> <div class="col-sm-2"> <span class="name label label-'+color+'">'+message.guest.name+'</span> </div> <div class="col-sm-10">'+message.content+'</div> </div>')
        code_block = $('[data-message-id="'+message.id+'"] pre code')[0]
        hljs.highlightBlock code_block if code_block
      $('#messages').scrollTop($('#messages')[0].scrollHeight) if scroll_flag && is_btm
    .always () -> setTimeout(pull_messages, 1000)
  pull_messages()