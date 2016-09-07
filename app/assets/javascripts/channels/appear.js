var room = decodeURIComponent(window.location.pathname.match(/^\/([^/]+)/)[1])
App.appear = App.cable.subscriptions.create({
  channel: 'AppearChannel',
  room: room
}, {
  connected: function() {
    console.debug('connected')
    this.perform('broadcast_appearance', {on: 'create'})
  },
  disconnected: function() {
    console.debug('disconnected')
  },
  received: function(data) {
    if(!Array.isArray(data) && data.action == 'create') data = [data]
    if(Array.isArray(data)){
      var html = data.map(function(msg){
        return JST['templates/guest'](msg)
      }).reduce(function(previous, current){
        return previous + current
      })
      var template = document.createElement('template')
      template.innerHTML = html
      document.getElementById('guests').appendChild(template.content)
    }else if(data.action == 'delete'){
      var target = document.getElementById('guest_' + data.id)
      target.parentNode.removeChild(target)
    }
  }
})
