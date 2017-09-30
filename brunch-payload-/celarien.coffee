###
#global Pylon
###
T = Pylon.Teact

Backbone = require 'backbone'
_= require 'underscore'


$ ->
  try
    FontFaceObserver = require 'font-face-observer'
    observeTeamSpirit = new FontFaceObserver "TeamSpirit",
      weight: 400
    observeTeamSpirit.check(null, 10000)
      .then(
        ()-> document.documentElement.className += " team-spirit-loaded"
        ()->  console.warn "TeamSpirit Font Problem?!"
        )

    observeVidaLoca = new FontFaceObserver "vidaloka",
      weight: 400
    observeVidaLoca.check(null, 10000)
      .then(
        ()->  document.documentElement.className += " vidaloka-loaded"
        ()->  console.warn "Vida Loka Font Problem?!"
        )
    observeVastShadow = new FontFaceObserver "vastshadow",
      weight: 400
    observeVastShadow.check(null, 10000)
      .then(
        ()->  document.documentElement.className += " vastshadow-loaded"
        ()->  console.warn "vastshadow Font Problem?!"
        )

  catch badDog
    console.log "Font Loader Error-- OK for site-master build phase"
    console.log badDog
  
console.log "Proceeding after font load"  

module.exports =  class CelarienLook
  constructor: (@T=T)->
    return this
 
  widgetWrap: ->
    {attrs,contents} = T.normalizeArgs arguments
    id = attrs.id
    delete attrs.id
    title = attrs.title
    delete attrs.title
    T.div '.Container.widget-wrap.p1.m1.border-bottom',attrs , ->
      T.h3 title unless !title
      T.p '.pl2',contents
  