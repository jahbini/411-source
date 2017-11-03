###
styling: "Lookand Feel"
###
T = require "halvalla"
_= require 'underscore'
try
  HeaderLogoNav = require '/site-server-master/public/server/header-logo-nav.coffee'
  Footer = require '/site-server-master/public/server/footer.coffee'
  console.log "Proceeding OK after header,footer require"  
catch ermsg
  console.log "header-logo-nav exploded",ermsg
  console.log "Fail in header,footer require"  
    

    
module.exports = T.bless class BodyFormatter extends T.Component
  constructor:(args...)->
    super(args...)
    #console.log "CELARIEN SERVERSIDE CONSTRUCT", props
    return
    
  view: (props)=>
    #console.log "CELARIEN SERVERSIDE", props
    final = props.page.final
    story = props.story

    headerOptions = _.pick props, ['navLinks','story','page']
    #console.log "CELARIEN SERVERSIDE headerOptions", headerOptions
    T.div '#celarien-body.c-text.o-grid.o-grid--full', ->
      T.tag 'style', '',".c-hero { border-bottom: 1px solid #333; }"
      T.div '.c-hero.o-grid__cell.u-higher', ()->
        HeaderLogoNav '#myheader', headerOptions 
      T.div '.o-grid__cell', style: 'minHeight':'100vh', ->
        T.div '.o-grid', ->
          T.tag "main", '#storybar.o-grid__cell.order-2.bg-lighten-2', ->
            T.h1 story.title
            T.hr()
            T.tag "Bloviation", ".contents", dangerouslySetInnerHTML: __html: final
          T.aside "#sidebar.o-grid__cell.o-grid__cell--width-20.p2.bg-darken-2",style: 'minWidth':240
          T.div "#sidecar.o-grid__cell.o-grid__cell--width-fixed.order-last.bg-darken-2", style: 'minWidth':240,()->
            T.div ".fb-login-button", height:48,
              width:200 
              'data-width': "200"
              'data-max-rows': "1"
              'data-size': "medium"
              'data-button-type': "login_with"
              'data-show-faces': "true"
              'data-auto-logout-link': "true"
              'data-use-continue-as': "true"
            T.div '#fb-status'    
      Footer '.o-grid__cell'

      T.div "#cover",
        style:
          'backgroundImage':'url(/assets/images/hooray-fade2.jpg)'
          'MozTransform':'scaleX(-1)'
          'OTransform':'scaleX(-1)'
          'WebkitTransform':'scaleX(-1)'
          'transform':'scaleX(-1)'
          'filter':'FlipH'
          'msFilter':'FlipH'
