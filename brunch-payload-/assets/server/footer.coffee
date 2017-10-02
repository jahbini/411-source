###
styling: "skeleton"
_options:

###
React = require 'react'
T = require "teact"

module.exports = T.bless class Footer extends React.Component
  render: () =>
    story = @props.story
    T.div "#footer.panel", bg: 'white', ->
        T.h2 "All contents copyright 2015, James A. Hinds"
        T.p "The ideas are yours to keep and share, the wording is mine."
