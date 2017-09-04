###
styling: "skeleton"
_options:

###
React = require 'react'
T = require "teact"

module.exports = T.bless class HeaderLogoNav extends React.Component
  render: ()=>
    story = @props.story
    T.header "#header.flex.justify-around.content-end", style: height:'250px',  ->
      T.h1 ".header-title.self-end", ->
        T.a ".header-title-link", href:"/ ", "Home"
      avatarStyle =
        'background-image':'url(/assets/images/hooray-fade2.jpg)'
        '-moz-transform':'scaleX(-1)'
        '-o-transform':'scaleX(-1)'
        '-webkit-transform':'scaleX(-1)'
        'transform':'scaleX(-1)'
        'filter':'FlipH'
        '-ms-filter':'FlipH'
      T.a ".header-right-picture.self-center", href:"/#about",->
        T.img '.circle',
        style: avatarStyle
        src:"http://www.gravatar.com/avatar/c105eda1978979dfb13059b8878ef95d?s=90"
      T.div "#sidecar.self-end.content-end",()->
        T.div ".fb-login-button.bg-gray", height:48,
          width: 300
          'data-width': "33rem"
          'data-max-rows': "1"
          'data-size': "large"
          'data-button-type': "login_with"
          'data-show-faces': "true"
          'data-auto-logout-link': "true"
          'data-use-continue-as': "true"
        T.div '#fb-status'     
