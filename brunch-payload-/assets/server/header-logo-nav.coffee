###
styling: "skeleton"
_options:

###
React = require 'react'
T = require "teact"

module.exports = T.bless class HeaderLogoNav extends React.Component
  constructor: (props)->
    super()
    @props=props
    @
    
  render: ()=>
    story = @props.story
    navLinks =@props.navLinks
    id = @props.id || 'header'
    avatarStyle =
      #'backgroundImage':'url(/assets/images/hooray-fade2.jpg)'
      'MozTransform':'scaleX(-1)'
      'OTransform':'scaleX(-1)'
      'WebkitTransform':'scaleX(-1)'
      'transform':'scaleX(-1)'
      'filter':'FlipH'
      'msFilter':'FlipH'
    T.header "##{id}.o-grid.o-grid--bottom", style: height:'250px',  ->
      T.div ".o-grid__cell.o-grid__cell--width-30", ->
        for link in navLinks
          T.h3 "", ->
            T.a ".fa.fa-#{link.key}", href:link.href, link.label
#      T.div '.o-grid__cell.o-grid__cell--width-10', ->
        T.div '.c-avatar.u-super',->
          T.img '.c-avatar__img',
            style: avatarStyle
            src:"http://www.gravatar.com/avatar/c105eda1978979dfb13059b8878ef95d?s=90"
      
