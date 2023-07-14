# #-------- class start
doHtml = true
renderer = class index extends siteTemplate
  # 
  # section html
  # 
  # 
  # section site_body
  # 
  # 
  # section cover
  # 
  # 
  # section footer
  # 
  # 
  # section sidecar
  # 
  # 
  # section fb_status
  # 
  # 
  # section sidebar
  # 
  # 
  # section storyBar
  storyBar: =>
    if doHtml
      doHtml=false
      @html()
    else
      T.raw "<slot:storyBar/>"
  # 
  # 
  # 
  # section bloviation
  # 
  bloviation: =>
      T.raw "<slot:bloviation>"
  # 
  # section header
  # 
  allMeta = [[["name","author"],["content","James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"]],[["http-equiv","Content-Type"],["content","text/html"],["charset","UTF-8"]],[["name","viewport"],["content","width=device-width, initial-scale=1"]],[["name","description"],["content","some good thoughts. Maybe."]],[["name","keywords"],["content","romance, wisdom, tarot"]],[["property","fb:admins"],["content","1981510532097452"]],[["name","msapplication-TileColor"],["content","#ffffff"]],[["name","msapplication-TileImage"],["content","/assets/icons/ms-icon-144x144.png"]],[["name","theme-color"],["content","#ffffff"]]]
  htmlTitle = "Practical Metaphysics and Harmonious Mana."
#-------- class end


# ------- db start
db = {} unless db

#
db[id="411-source/app/app"] =
  title: "app"
  slug: "app"
  category: "app"
  site: "411-source"
  accepted: false
  index: false
  sourcePath: ""
  headlines: []
  tags: []
  snippets: "{\"first name\":\"first name\"}"
  memberOf: []
  created: "2023-07-11T14:57:14.696Z"
  lastEdited: "2023-07-11T14:57:14.696Z"
  published: "2023-07-11T14:57:14.696Z"
  embargo: "2023-07-11T14:57:14.696Z"
  captureDate: "2023-07-11T14:57:14.696Z"
  TimeStamp: 1689087434696
  debug: ""
  author: "James A. Hinds: The 411-source's best friend.  I'm not him, I wear glasses"
  id: "411-source/app/app"
  name: "app"
#
#end of story
