###
styling: "Lookand Feel"
###
T = require "teact"

try
  headerLogoNav = require './header-logo-nav.coffee'
  myfooter = require './footer.coffee'
catch
  try
    headerLogoNav = require 'payload-/header-logo-nav.coffee'
    myfooter = require 'payload-/footer.coffee'
  catch e
    console.log "Fail in header,footer require"  
    
  
console.log "Proceeding after header,footer require"  

module.exports = class CelarienLook
  constructor: (@T=T)->
    return this
    
  widgetWrap: ->
      {attrs,contents} = T.normalizeArgs arguments
      id = attrs.id
      delete attrs.id
      title = attrs.title
      delete attrs.title
      attrs.className = "widget-wrap"
      T.div attrs , ->
        T.h3 ".widget-title.white", title unless !title
        T.div ".widget.white", contents


  formatStory: (story) ->
    options = story.attributes

    T.body ->
      T.div '.flex.flex-column', style: 'min-height:100vh', ->
        T.header '.center.flex-wrap.p2.border-bottom.bg-darken-4', ->
          T.a  href: '//bamboosnow.com', target: '_blank', ->
            T.h1 '.white', ->
              T.img '#logoimg.h1.col-2.align-middle',src: 'assets/images/logo.svg', width: "150px"
              T.div '#slogan.inline-block.col-10.align-middle', 'Bamboo Snow -- Multi-Purpose Boon for the World'
  
        T.div '.flex-auto.md-flex', ->
          T.tag "main", '#storybar.flex-auto.order-1.p2.bg-lighten-4', ->
            T.h1 options.title
            T.hr()
            T.raw story.tmp.cooked || story.get "final"
          T.nav '#sidebar.order-0.bg-darken-2.flex-auto.col-3', style: 'min-width:22rem', ->
              T.h1 "Sidebar"
              T.p 'Sidebar'
          if false
            T.aside '#sidebar2.p2.border-left.order-3.col-2', style: 'min-width:8rem', ->
              T.h1 "Sidebar2"
              T.p 'Sidebar2'
        T.footer '.p2.border-top.bg-silver', ->
          T.h2 '.center.m0','All contents copyright 2005-2017, James A. Hinds'
          T.div '.center',->
            T.img '.circle', src: 'http://www.gravatar.com/avatar/c105eda1978979dfb13059b8878ef95d'
            T.br()
            T.text 'AKA Bamboo Jim'
          T.h4 '.center.m0','The ideas are yours to keep and share, the wording is mine.'
          T.br()
          T.a href: 'http://basscss.com/', target: '_blank', 'CSS -- BassCss.com'
      T.div "#cover", style:"background-image:url(/assets/images/cover.jpg);-moz-transform:scaleX(-1); -o-transform: scaleX(-1); -webkit-transform: scaleX(-1); transform: scaleX(-1); filter: FlipH; -ms-filter: 'FlipH';"
