###
styling: "Lookand Feel"
###
React = require 'react'
T = require "teact"

try
  HeaderLogoNav = require '/site-server-master/public/server/header-logo-nav.coffee'
  Footer = require '/site-server-master/public/server/footer.coffee'
  console.log "Proceeding OK after header,footer require"  
catch ermsg
  console.log "header-logo-nav exploded",ermsg
  console.log "Fail in header,footer require"  
    
  
module.exports = T.bless class BodyFormatter extends React.Component

  render: ()=>
    final = @props.page.final
    story = @.props.story

    T.div '#celarien-body', ->
      T.div '.flex.flex-column', style: 'min-height':'100vh', ->
        HeaderLogoNav @props
        T.div '.flex-auto.md-flex', ->
          T.crel "main", '#storybar.flex-auto.order-1.p2.bg-lighten-4', ->
            T.h1 story.title
            T.hr()
            T.crel "Bloviation", ".contents", dangerouslySetInnerHTML: __html: final
          T.aside "#sidebar",style: 'min-width':240
        Footer '.p2.border-top.bg-silver'

      T.div "#cover",
        style:
          'background-image':'url(/assets/images/hooray-fade2.jpg)'
          '-moz-transform':'scaleX(-1)'
          '-o-transform':'scaleX(-1)'
          '-webkit-transform':'scaleX(-1)'
          'transform':'scaleX(-1)'
          'filter':'FlipH'
          '-ms-filter':'FlipH'
