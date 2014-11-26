$(document).on 'page:change', () ->
  # send message
  $('#new_message')
    .on 'ajax:success', (event, data) ->
      $('#message_content').val('')
      alert(data.msg) if data.msg
    .on 'ajax:error', () -> alert('出錯了')
    .on 'ajax:complete', () -> $('#message_content').attr('disabled', false).focus()
  $("#message_content")
    .keypress (e) ->
      if e.which == 13 && !e.shiftKey && $('#message_content').val().trim().length > 0
        e.preventDefault()
        $(this.form).submit()
        this.disabled = true
    .focus()
  pull_messages = () ->
    last_read_message_id = $('.message:last-child').attr('id') && $('.message:last-child').attr('id').match(/\d+$/)[0]
    $.get '/rooms/' + $('#room').data('slug') + '/messages', last_read_message_id: last_read_message_id
    .done (raw_html) ->
      scroll_flag = false
      is_btm = $('#messages').height() + $('#messages').scrollTop() >= $('#messages')[0].scrollHeight - 10
      jquery_html = $(raw_html)
      scroll_flag = true if raw_html
      hljs.highlightBlock code_block for code_block in jquery_html.find('pre code')
      $('#messages').append(jquery_html)
      $('#messages').scrollTop($('#messages')[0].scrollHeight) if scroll_flag && is_btm
    .always () -> setTimeout(pull_messages, 1000)
  pull_messages()