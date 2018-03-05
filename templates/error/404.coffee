# #-------- class start
class  index extends celarientemplate
  # 
  # section html
  # 
  # 
  # section celarien_body
  # 
  # 
  # section cover
  # 
  cover: =>
    T.div "#cover", style: "background-image:url(/assets/images/hooray-fade2.jpg);-moz-transform:scaleX(-1);-o-transform:scaleX(-1);-webkit-transform:scaleX(-1);transform:scaleX(-1);filter:FlipH;ms-filter:FlipH"
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
      @bloviation()
  # 
  # section bloviation
  # 
  bloviation: =>
    T.div "#bloviation.contents", =>
      T.raw "Sorry, that does not exist...   Yet."
      T.a href: "/announcement/two-years-with-bamboo-snow.html", => T.raw " but check out an incredible life with Bamboo Snow."
  # 
  # section header
  # 
  allMeta = [[["name","author"],["content","James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"]],[["http-equiv","Content-Type"],["content","text/html"],["charset","UTF-8"]],[["name","viewport"],["content","width=device-width, initial-scale=1"]],[["name","description"],["content","some good thoughts. Maybe."]],[["name","keywords"],["content","romance, wisdom, tarot"]],[["property","fb:admins"],["content","1981510532097452"]],[["name","msapplication-TileColor"],["content","#ffffff"]],[["name","msapplication-TileImage"],["content","/assets/icons/ms-icon-144x144.png"]],[["name","theme-color"],["content","#ffffff"]]]
  htmlTitle = "Practical Metaphysics and Harmonious Mana."
#-------- class end
page = new index
rendered =  T.render page.html
# ------- db start
db = {} unless db


#end of story#
db[id="celarienerror404"] =
  title: "404"
  slug: "404"
  category: "error"
  site: "597aea40d3cfff7cc5f926f0"
  accepted: true
  index: false
  sourcePath: ""
  headlines: []
  tags: []
  snippets: "{\"first name\":\"first name\"}"
  memberOf: []
  created: "2018-03-05T04:47:09.128Z"
  lastEdited: "2018-03-05T04:47:09.129Z"
  published: "2018-03-05T04:47:09.129Z"
  embargo: "2018-03-05T04:47:09.129Z"
  captureDate: "2018-03-05T04:47:09.129Z"
  TimeStamp: 1520225229129
  debug: ""
  author: "James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"
  id: "celarienerror404"
  name: "404"
#