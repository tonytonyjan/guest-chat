$(document).on 'page:change', () ->
  source = new EventSource('http://localhost:3310' + location.pathname)
  source.addEventListener 'message', (e) ->
    msg = JSON.parse(e.data)
    console.log(msg)