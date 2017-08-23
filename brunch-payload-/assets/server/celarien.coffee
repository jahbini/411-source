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

    T.body ->
      T.div '.flex.flex-column', style: 'min-height':'100vh', ->
        HeaderLogoNav @props
        T.div '.flex-auto.md-flex', ->
          T.crel "main", '#storybar.flex-auto.order-1.p2.bg-lighten-4', ->
            T.h1 story.title
            T.hr()
            T.crel "Bloviation", ".contents", dangerouslySetInnerHTML: __html: final
          T.div "#sidecar",()->
              T.div ".fb-login-button.bg-gray", height:48,
                width: 300
                'data-width': "33rem"
                'data-max-rows': "1"
                'data-size': "large"
                'data-button-type': "login_with"
                'data-show-faces': "true"
                'data-auto-logout-link': "true"
                'data-use-continue-as': "true"
              T.aside "#sidebar"
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
