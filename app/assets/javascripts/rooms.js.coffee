$(document).on 'page:change', () ->
  # send message
  $('#new_message').on 'ajax:success', (event, message) ->
    $('#message_content').val('')
  .on 'ajax:error', () ->
    alert('出錯了')
  $("#message_content").keypress (e) ->
    $(this.form).submit() if e.which == 13 && !e.shiftKey
  # max height
  set_height = () ->
    $('#messages').height window.innerHeight-110
  set_height()
  window.addEventListener('resize', set_height)
  # pulling
  pull_messages = () ->
    $.ajax
      url: '/rooms/' + $('#room').data('slug') + '/messages.json'
      data:
        read_message_ids: (message.getAttribute('data-message-id') for message in $('.message'))
    .done (messages) ->
      scroll_flag = false
      is_btm = $('#messages').height() + $('#messages').scrollTop() >= $('#messages')[0].scrollHeight - 10
      for message in messages
        scroll_flag = true
        color = if message.guest.id == $('#current_guest').data('id') then 'warning' else 'primary'
        $('#messages').append('<div class="row message" data-message-id="'+message.id+'"> <div class="col-sm-1"> <span class="label label-'+color+'">'+message.guest.name+'</span> </div> <div class="col-sm-11">'+message.content+'</div> </div>')
        code_block = $('[data-message-id="'+message.id+'"] pre code')[0]
        hljs.highlightBlock code_block if code_block
      $('#messages').scrollTop($('#messages')[0].scrollHeight) if scroll_flag && is_btm
    setTimeout(pull_messages, 1000)
  pull_messages()