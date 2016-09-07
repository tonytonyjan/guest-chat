//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require material-design-lite/material
//= require moment/moment
//= require moment/locale/zh-tw.js
//= require_tree ./templates
//= require cable

document.addEventListener('DOMContentLoaded', function(){
  var $form = document.querySelector('.submit-form')
  var $textArea = $form.querySelector('textarea')
  var $main = document.getElementById('main')

  $form.addEventListener('submit', handleSubmit.bind(this))
  $textArea.addEventListener('input', handleInput.bind(this))
  $textArea.addEventListener('keypress', handleKeyPress.bind(this))

  setInterval(updateTime, 5)

  function handleSubmit(){
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
    App.chat.send({ content: $textArea.value })
    $textArea.value = ''
  }

  function updateTime(){
    for (var time of document.querySelectorAll('[data-time]')) {
      time.childNodes[0].nodeValue = moment(time.dataset.time).fromNow()
    }
  }
})
