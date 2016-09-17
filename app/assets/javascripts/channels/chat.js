componentHandler.registerUpgradedCallback('MaterialLayout', function(e){
  var room = decodeURIComponent(window.location.pathname.match(/^\/([^/]+)/)[1])
  var guest_id = document.getElementById('me').childNodes[0].nodeValue
  App.chat = App.cable.subscriptions.create({
    channel: 'ChatChannel',
    room: room
  }, {
    connected: function() {
      console.debug('connected')
    },
    disconnected: function() {
      console.debug('disconnected')
    },
    received: function(data) {
      if(Array.isArray(data)){
        var html = data.map(this.msg_to_s).reduce(function(previous, current){
          return previous + current
        })
        this.append_message_from_html(html)
      }else{
        if(guest_id != data.guest_id){
          Notification.requestPermission(function(permission) {
            if(permission === 'granted'){
              new Notification(data.name, {
                body: data.content,
                icon: data.avatar,
                tag: data.name,
                renotify: true
              })
            }
          })
        }
        var html = this.msg_to_s(data)
        this.append_message_from_html(html)
      }
      var main = document.getElementById('main')
      main.scrollTop = main.scrollHeight
    },
    msg_to_s: function(msg){
      return JST['templates/message']({
        name: msg.name,
        avatar: msg.avatar,
        content: marked(msg.content),
        time: msg.created_at,
        timeFromNow: moment(msg.created_at).fromNow(),
        isMe: msg.guest_id == guest_id,
        adj: msg.adj,
        noun: msg.noun
      })
    },
    html_to_ele: function(html){
      var template = document.createElement('template')
      template.innerHTML = html
      return template.content
    },
    append_message_from_html: function(html){
      var dom = this.html_to_ele(html)
      document.getElementById('messages').appendChild(dom)
    }
  })
})
