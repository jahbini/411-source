# #-------- class start
renderer = class  index extends celarientemplate
  # 
  # section html
  # 
  # 
  # section celarien_body
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
  # section storybar
  # 
  storybar: =>
    T.div "#storybar.o-grid__cell.order-2.bg-lighten-2", =>
      T.h1 => T.raw "Celarien -- The tools of the spiritual bodyguard"
      T.hr()
      #@hypno()
      @bloviation()
  #
  # section hypno
  #
  hypno: =>
    T.div ".outer",=>
      T.style scoped:true ,"""
@keyframes hinge {
  0% {
    transform-origin: top left;
    animation-timing-function: ease-in-out;
  }

  20%,
  60% {
    transform: rotate3d(0, 0, 1, 80deg);
    transform-origin: top left;
    animation-timing-function: ease-in-out;
  }

  40%,
  80% {
    transform: rotate3d(0, 0, 1, 60deg);
    transform-origin: top left;
    animation-timing-function: ease-in-out;
    opacity: 1;
  }

  to {
    transform: translate3d(0, 700px, 0);
    opacity: 0;
  }
}

.hinge {
  animation-duration: 2s;
  animation-name: hinge;
}
"""
  # 
  # section bloviation
  # 
  bloviation: =>
    T.div "#bloviation.contents", =>
      T.p "Let's talk Angels."
      T.p ".border", """Somebody once asked me if there were any angels in the room"""
      T.p """But this note from a good friend actually had something worthy to say.  And it is so worthy that if I didn't pass it on, i'd be 
"""
  # 
  # section header
  # 
  allMeta = [[["name","author"],["content","James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"]],[["http-equiv","Content-Type"],["content","text/html"],["charset","UTF-8"]],[["name","viewport"],["content","width=device-width, initial-scale=1"]],[["name","description"],["content","some good thoughts. Maybe."]],[["name","keywords"],["content","romance, wisdom, tarot"]],[["property","fb:admins"],["content","1981510532097452"]],[["name","msapplication-TileColor"],["content","#ffffff"]],[["name","msapplication-TileImage"],["content","/assets/icons/ms-icon-144x144.png"]],[["name","theme-color"],["content","#ffffff"]]]
  htmlTitle = "Practical Metaphysics and Harmonious Mana."
#-------- class end


# ------- db start
db = {} unless db

#
db[id="celarienmetaphysics_101angels"] =
  title: "angels"
  slug: "angels"
  category: "metaphysics_101"
  site: "celarien"
  accepted: false
  index: false
  sourcePath: ""
  headlines: []
  tags: []
  snippets: "{\"first name\":\"first name\"}"
  memberOf: []
  created: "2018-03-26T19:54:07.400Z"
  lastEdited: "2018-03-26T19:54:07.401Z"
  published: "2018-03-26T19:54:07.401Z"
  embargo: "2018-03-26T19:54:07.401Z"
  captureDate: "2018-03-26T19:54:07.401Z"
  TimeStamp: 1522094047401
  debug: ""
  author: "James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"
  id: "celarienmetaphysics_101angels"
  name: "angels"
#
#end of story



db[id="celarien/metaphysics_101/angels"] =
  title: "angels"
  slug: "angels"
  category: "metaphysics_101"
  site: "celarien"
  accepted: false
  index: false
  sourcePath: ""
  headlines: []
  tags: []
  snippets: "{\"first name\":\"first name\"}"
  memberOf: []
  created: "2018-03-26T19:54:07.400Z"
  lastEdited: "2018-03-26T19:54:07.401Z"
  published: "2018-03-26T19:54:07.401Z"
  embargo: "2018-03-26T19:54:07.401Z"
  captureDate: "2018-03-26T19:54:07.401Z"
  TimeStamp: 1522094047401
  debug: ""
  author: "James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"
  id: "celarien/metaphysics_101/angels"
  name: "angels"
#