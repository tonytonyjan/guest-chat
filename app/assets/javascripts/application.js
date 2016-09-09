//= require jquery
//= require jquery_ujs
//= require material-design-lite/material
//= require moment/moment
//= require moment/locale/zh-tw.js
//= require markdown/lib/markdown
//= require_tree ./templates
//= require cable

componentHandler.registerUpgradedCallback('MaterialLayout', function(e){
  var $form = document.querySelector('.submit-form')
  var $textArea = $form.querySelector('textarea')
  var $main = document.getElementById('main')

  $form.addEventListener('submit', handleSubmit.bind(this))
  $textArea.addEventListener('input', handleInput.bind(this))
  $textArea.addEventListener('keypress', handleKeyPress.bind(this))

  setInterval(updateTime, 5000)

  function handleSubmit(e){
    e.preventDefault()
    sendMessage()
  }

  function handleInput(e) {
    var lines = e.target.value.split(/\r\n|\r|\n/).length
    if(lines > 10) lines = 10
    e.target.rows = lines
  }

  function handleKeyPress(e) {
    if(e.key == 'Enter' && !e.shiftKey){
      e.preventDefault()
      sendMessage()
    }
  }

  function sendMessage(){
    var trimed = $textArea.value.trim()
    if(trimed.length == 0) return
    App.chat.send({ content: trimed })
    $textArea.value = ''
  }

  function updateTime(){
    var list = document.querySelectorAll('[data-time]')
    for (var i = 0; i < list.length; i++) {
      var time = list[i]
      time.childNodes[0].nodeValue = moment(time.dataset.time).fromNow()
    }
  }
})
