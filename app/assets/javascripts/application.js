//= require jquery
//= require jquery_ujs
//= require material-design-lite/material
//= require moment/moment
//= require moment/locale/zh-tw
//= require marked/lib/marked
//= require highlight.pack.js
//= require_tree ./templates
//= require cable

var renderer = new marked.Renderer()
renderer.code = function(code, lang, escaped) {
  if (this.options.highlight) {
    var out = this.options.highlight(code, lang);
    if (out != null && out !== code) {
      escaped = true;
      code = out;
    }
  }
  if (!lang) {
    return '<pre><code class="hljs">'
      + (escaped ? code : escape(code, true))
      + '\n</code></pre>';
  }

  return '<pre><code class="'
    + this.options.langPrefix
    + escape(lang, true)
    + '">'
    + (escaped ? code : escape(code, true))
    + '\n</code></pre>\n';
};

marked.setOptions({
  breaks: true,
  sanitize: true,
  langPrefix: 'hljs ',
  renderer: renderer,
  highlight: function(code, lang){
    if(hljs.getLanguage(lang))
      return hljs.highlight(lang, code).value
    else
      return hljs.highlightAuto(code).value
  }
})

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
    if((e.key == 'Enter' || e.keyCode == 13) && !e.shiftKey){
      e.preventDefault()
      sendMessage()
    }
  }

  function sendMessage(){
    var trimed = $textArea.value.trim()
    if(trimed.length == 0) return
    App.chat.send({ content: $textArea.value })
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
