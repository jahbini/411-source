###
#global Pylon
###
T = Pylon.Halvalla
_= Pylon.underscore


$ ->
  try
    FontFaceObserver = require 'font-face-observer'
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
  
module.exports =  class CelarienLook
 
  widgetWrap: ->
    {attrs,contents} = T.normalizeArgs arguments
    id = attrs.id
    delete attrs.id
    title = attrs.title
    delete attrs.title
    T.div '.container.widget-wrap.p-2.my-1',attrs , ->
      T.h3 title unless !title
      T.div '.btn-group.btn-group-vertical.widget',->contents
  