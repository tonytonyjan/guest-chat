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
      if(!Array.isArray(data)) data = [data]
      var html = data.map(function(msg){
        return JST['templates/message']({
          name: msg.name,
          avatar: msg.avatar,
          content: msg.content,
          time: msg.created_at,
          timeFromNow: moment(msg.created_at).fromNow(),
          is_me: msg.guest_id == guest_id
        })
      }).reduce(function(previous, current){
        return previous + current
      })
      var template = document.createElement('template')
      template.innerHTML = html
      document.getElementById('messages').appendChild(template.content)
      var main = document.getElementById('main')
      main.scrollTop = main.scrollHeight
    }
  })
})
