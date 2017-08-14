###
styling: "skeleton"
_options:

###
React = require 'react'
T = require "teact"

module.exports = T.bless class HeaderLogoNav extends React.Component
  render: ()=>
    story = @props.story
    T.header "#header",  ->
      T.h1 ".header-title", ->
          T.a ".header-title-link", href:"/ ", "Home"
      T.div "#status"
      T.a ".header-right-picture", href:"/#about",->
        T.img ".header-picture",
         src:"http://www.gravatar.com/avatar/c105eda1978979dfb13059b8878ef95d?s=90"
      T.crel 'fb:login-button', scope: "public_profile,email", onlogin: "checkLoginState();"
      
  