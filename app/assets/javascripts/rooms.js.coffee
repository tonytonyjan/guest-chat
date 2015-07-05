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

  check_notificaiton = ->
    if typeof Notification == 'function'
      switch Notification.permission
        when 'granted' then true
        when 'denied'  then  false
        else Notification.requestPermission (permission) ->
          permission == 'granted'

  show_notification = (name, body, icon = undefined) ->
    return unless check_notificaiton()
    notification = new Notification "#{name} 說：",
        body: body
        icon: icon
    setTimeout(notification.close.bind(notification), 3000)

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
      # 只有在polling 的時候才會更新
      if last_read_message_id && jquery_html.size()
        $.each jquery_html, (i, message) ->
          # 判斷是不是自己發的
          unless $(message).find('.name').hasClass('label-warning')
            name = $(message).find('.name').text()
            content = $(message).find('.content p').html()
            show_notification(name, content)
      $('#messages').scrollTop($('#messages')[0].scrollHeight) if scroll_flag && is_btm
    .always () -> setTimeout(pull_messages, 1000)
  pull_messages()
  check_notificaiton()