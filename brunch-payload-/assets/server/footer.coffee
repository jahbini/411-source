###
styling: "skeleton"
_options:

###
T = require "halvalla"

module.exports = T.bless class MyFooter extends T.Component
  view:()=>@render arguments
  render: () =>
    T.div "#footer.panel", bg: 'white', ->
        T.h2 "All contents copyright 2015, James A. Hinds"
        T.p "The ideas are yours to keep and share, the wording is mine."
