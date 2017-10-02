###
styling: "Lookand Feel"
###
React = require 'react'
T = require "teact"
_= require 'underscore'
try
  HeaderLogoNav = require '/site-server-master/public/server/header-logo-nav.coffee'
  Footer = require '/site-server-master/public/server/footer.coffee'
  console.log "Proceeding OK after header,footer require"  
catch ermsg
  console.log "header-logo-nav exploded",ermsg
  console.log "Fail in header,footer require"  
    

holyGrail = T.bless class HolyGrail extends React.Component

  constructor: (@vnode)->
    @props = @vnode.props
    
  render: ()=>
    options = _.pluck @props, 'navLinks','story','page'
    T.div '.o-grid.o-grid--full', ()->
      options.header '.o-grid__cell',options
      
module.exports = T.bless class BodyFormatter extends React.Component
  constructor:(@props)->
    #console.log "CELARIEN SERVERSIDE CONSTRUCT", @props
    @
    
  render: ()=>
    #console.log "CELARIEN SERVERSIDE", @props
    final = @props.page.final
    story = @.props.story

    headerOptions = _.pick @props, ['navLinks','story','page']
    #console.log "CELARIEN SERVERSIDE headerOptions", headerOptions
    T.div '#celarien-body.c-text.o-grid.o-grid--full', ->
      T.crel 'style', '',".c-hero { border-bottom: 1px solid #333; }"
      T.div '.c-hero.o-grid__cell.u-higher', ()->
        HeaderLogoNav '#myheader', headerOptions 
      T.hr '.o-grid__cell'
      T.div '.o-grid__cell', style: 'minHeight':'100vh', ->
        T.div '.o-grid', ->
          T.crel "main", '#storybar.o-grid__cell.order-2.bg-lighten-2', ->
            T.h1 story.title
            T.hr()
            T.crel "Bloviation", ".contents", dangerouslySetInnerHTML: __html: final
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
