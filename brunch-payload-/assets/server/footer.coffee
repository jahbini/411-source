###
styling: "skeleton"
_options:

###
{doctype,html,title,meta,base,link,script,body,header,raw,section,
 comment,div,a,span,h1,h2,h3,h4,h5,h6,head,renderable,p,
 tag,footer} = require "teacup"
module.exports = renderable (story) ->
  options = story.attributes
  footer "#footer.main-content-wrap.bg-white", ->
    h2 "All contents copyright 2015, James A. Hinds"
    p "The ideas are yours to keep and share, the wording is mine."
