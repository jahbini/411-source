# #-------- class start
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
  # 
  # 
  # section bloviation
  # 
  bloviation: =>
    T.div "#bloviation.contents", =>
      T.canvas width:"400", height:"400", id:"seen-canvas"
      T.p "put your content here"
    T.coffeescript =>
      Pylon.on "loaded", ()->
        shape = seen.Shapes.tetrahedron
        shape = new seen.Shape('tri', [new seen.Surface([
            seen.P(-1, -1, 0)
            seen.P( 1, -1, 0)
            seen.P( 0,  1, 0)
        ])]).scale(height * 0.2)
        shape.fill(new seen.Material(seen.Colors.gray()))
        # Create scene and add shape to model
        scene = new seen.Scene
          model    : seen.Models.default().add(shape)
          viewport : seen.Viewports.center(400, 400)
          camera   : new seen.Camera
                  projection : seen.Projections.perspective()
        #
        # Create render context from canvas
        context = seen.Context 'seen-canvas', scene
        context.render()

        dragger = new seen.Drag('seen-canvas', {inertia : true})
        dragger.on 'drag.rotate', (e) ->
          shape.transform seen.Quaternion.xyToTransform(e.offsetRelative...)
          context.render()
  # 
  # section header
  # 
  storyHeadMatter: =>
    #T.script src:"//cdnjs.cloudflare.com/ajax/libs/coffee-script/1.7.1/coffee-script.min.js"
    T.script src:"assets/seen.min.js"

  allMeta = [[["name","author"],["content","James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"]],[["http-equiv","Content-Type"],["content","text/html"],["charset","UTF-8"]],[["name","viewport"],["content","width=device-width, initial-scale=1"]],[["name","description"],["content","some good thoughts. Maybe."]],[["name","keywords"],["content","romance, wisdom, tarot"]],[["property","fb:admins"],["content","1981510532097452"]],[["name","msapplication-TileColor"],["content","#ffffff"]],[["name","msapplication-TileImage"],["content","/assets/icons/ms-icon-144x144.png"]],[["name","theme-color"],["content","#ffffff"]]]
  htmlTitle = "Practical Metaphysics and Harmonious Mana."
#-------- class end


# ------- db start
db = {} unless db

#
db[id="411-source/spacefare/space-struts"] =
  title: "space-struts"
  slug: "space-struts"
  category: "spacefare"
  site: "411-source"
  accepted: false
  index: false
  sourcePath: ""
  headlines: []
  tags: []
  snippets: "{\"first name\":\"first name\"}"
  memberOf: []
  created: "2022-05-29T03:47:35.207Z"
  lastEdited: "2022-05-29T03:47:35.208Z"
  published: "2022-05-29T03:47:35.208Z"
  embargo: "2022-05-29T03:47:35.208Z"
  captureDate: "2022-05-29T03:47:35.208Z"
  TimeStamp: 1653796055208
  debug: ""
  author: "James A. Hinds: The 411-source's best friend.  I'm not him, I wear glasses"
  id: "411-source/spacefare/space-struts"
  name: "space-struts"
#
#end of story
