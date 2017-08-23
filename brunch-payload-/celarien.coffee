###
styling: "Lookand Feel"
###
T = Pylon.Teact

try
  $ ->
    FontFaceObserver = require 'font-face-observer'
    observeTeamSpirit = new FontFaceObserver "TeamSpirit",
      weight: 400
    observeTeamSpirit.check(null, 10000)
      .then(
        ()-> document.documentElement.className += " team-spirit-loaded"
        ()->  alert "TeamSpirit Font Problem?!"
        )

    observeVidaLoca = new FontFaceObserver "vidaloka",
      weight: 400
    observeVidaLoca.check(null, 10000)
      .then(
        ()->  document.documentElement.className += " vidaloka-loaded"
        ()->  alert "Vida Loka Font Problem?!"
        )
    observeVastShadow = new FontFaceObserver "vastshadow",
      weight: 400
    observeVastShadow.check(null, 10000)
      .then(
        ()->  document.documentElement.className += " vastshadow-loaded"
        ()->  alert "vastshadow Font Problem?!"
        )

catch badDog
  console.log "Font Loader Error-- OK for site-master build phase"
  console.log badDog
  
console.log "Proceeding after font load"  

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
    T.Container attrs , ->
    T.Border bottom: true, ()->
      T.Text f:3, color: 'black', bg: '#c5a317', title unless !title
      T.div contents
  