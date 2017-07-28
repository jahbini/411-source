###
styling: "skeleton"
_options:

###
T = require "teacup"

module.exports = T.renderable (story) ->
  options = story.attributes
  siteHandle = story.get 'siteHandle'
  T.header "#header", "data-behavior":"1", ->
    T.i "#btn-open-sidebar.fa.fa-lg.fa-bars"
    T.h1 ".header-title", ->
        T.a ".header-title-link", href:"/ ", "Home"
    T.a ".header-right-picture", href:"/#about",->
      T.img ".header-picture",
       src:"http://www.gravatar.com/avatar/c105eda1978979dfb13059b8878ef95d?s=90"
