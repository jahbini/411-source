###
styling: "skeleton"
_options:

###
{doctype,html,title,meta,base,link,script,body,header,raw,section,
 comment,i,img,div,a,span,h1,h2,h3,h4,h5,h6,head,renderable,nav,ul,li,
 tag,footer} = require "teacup"

module.exports = renderable (story) ->
  options = story.attributes
  siteHandle = story.get 'siteHandle'
  T.header "#header", "data-behavior":"1", ->
    T.h1 ".header-title", ->
        T.a ".header-title-link", href:"/ ", "Home"
    T.div "#status"
    T.a ".header-right-picture", href:"/#about",->
      T.img ".header-picture",
       src:"http://www.gravatar.com/avatar/c105eda1978979dfb13059b8878ef95d?s=90"
    T.raw '<fb:login-button scope="public_profile,email" onlogin="checkLoginState();">
</fb:login-button>'
    
