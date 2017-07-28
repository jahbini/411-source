###
styling: "Lookand Feel"
###
ST = require "teact"
T = require "teacup"

try
  $ ->
    FontFaceObserver = require 'font-face-observer'
    observeTeamSpirit = new FontFaceObserver "TeamSpirit",
      weight: 400
    observeTeamSpirit.check(null, 10000)
      .then(
        ()-> document.documentElement.className += " team-spirit-loaded"
        ()->  console.log "TeamSpirit Font Problem?!"
        )

    observeVidaLoca = new FontFaceObserver "vidaloka",
      weight: 400
    observeVidaLoca.check(null, 10000)
      .then(
        ()->  document.documentElement.className += " vidaloka-loaded"
        ()->  console.log "Vida Loka Font Problem?!"
        )
    observeVastShadow = new FontFaceObserver "vastshadow",
      weight: 400
    observeVastShadow.check(null, 10000)
      .then(
        ()->  document.documentElement.className += " vastshadow-loaded"
        ()->  console.log "vastshadow Font Problem?!"
        )

catch badDog
  console.log "Font Loader Error-- OK for site-master build phase"
  console.log badDog

console.log "Proceeding after font load"

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
      if attrs.class?
        attrs.class.push "widget-wrap"
      else
        attrs.class = [ "widget-wrap"]
      T.div attrs , ->
        T.h3 ".widget-title.white", title unless !title
        T.div ".widget.white", contents


  formatStory: T.renderable (story) ->
    options = story.attributes

    T.comment "\nThe Body\n"
    T.body ->
      T.div '.flex.flex-column', style: 'min-height:100vh', ->
        T.header '.center.flex-wrap.p2.border-bottom.bg-darken-4', ->
          T.a  href: '//celarien.com', target: '_blank', ->
            T.h1 '.white', ->
              T.img '#logoimg.h1.col-2.align-middle',src: 'assets/images/logo.svg', width: "150px"
              T.div '#slogan.inline-block.col-10.align-middle', 'Words of Wisdom from odd and natural sources.'

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
          T.h2 '.center.m0','All contents copyright 2015, James A. Hinds'
          T.div '.center',->
            T.img '.circle', src: 'http://www.gravatar.com/avatar/c105eda1978979dfb13059b8878ef95d'
            T.br()
            T.text 'AKA Bamboo Jim'
          T.h4 '.center.m0','The ideas are yours to keep and share, the wording is mine.'
          T.br()
          T.a href: 'http://basscss.com/', target: '_blank', 'CSS -- BassCss.com'
      T.div "#cover", style:"background-image:url(/assets/images/cover.jpg);"
