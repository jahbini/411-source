###
styling: "skeleton"
_options:

###
T  = require "teacup"
module.exports = T.renderable (story) ->
  options = story.attributes
  T.footer "#footer.main-content-wrap.bg-white", ->
    T.h2 "All contents copyright 2015, James A. Hinds"
    T.p "The ideas are yours to keep and share, the wording is mine."
