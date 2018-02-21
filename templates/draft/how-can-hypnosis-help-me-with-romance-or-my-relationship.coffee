# 
class how_can_hypnosis_help_me_with_romance_or_my_relationship extends celarientemplate
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
      T.h1 => T.raw "How can hypnosis help me with romance or my relationship?"
      T.hr()
      @bloviation()
  # 
  # section bloviation
  # 
  bloviation: =>
    T.div "#bloviation.contents", "dangerously-set-inner-h-t-m-l": "[object Object]", =>
      T.p => T.raw "The most important person in most people’s lives is their life partner.  Let’s use that term from  the 1980’s “Significant Other.”  This is the relationship that has the potential for maximum payoff or maximum pain.  There is a general agreement that these relationships are not always successful in our culture.  For example, less that 50% of elegible people are married."
      T.p =>
        T.raw "Great strides have been made in the last few years by researchers, including"
        T.a href: "http://www.google.com/search?q=john+gottman", => T.raw "Dr. John Gottman"
        T.raw "and Marriage counselor"
        T.a href: "http://www.google.com/search?q=lee+baucom", => T.raw "Lee Baucom"
        T.raw ", about what attitudes and behaviors can predict failure and success with a life partner.  But how can you get those attitudes that lead to successful behaviors?  Hypnosis and The Celarien Experience can help you with this, before, during or even after a relationship."
      T.p =>
        T.raw "The Celarien Experience has been focused on relationships and the eternal romance that you need to put in place so you can treat your Significant Other in the best possible way for success.  Visit our sister web-sites"
        T.a href: "http://romancecapitol.com/", => T.raw "Romance Capitol"
        T.raw "and"
        T.a href: "http://romantictrances.com/", => T.raw "Romantic Trances"
        T.raw "for more information."
  # 
  # section header
  # 
  allMeta = [[["name","author"],["content","James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"]],[["http-equiv","Content-Type"],["content","text/html"],["charset","UTF-8"]],[["name","viewport"],["content","width=device-width, initial-scale=1"]],[["name","description"],["content","some good thoughts. Maybe."]],[["name","keywords"],["content","romance, wisdom, tarot"]],[["property","fb:admins"],["content","1981510532097452"]],[["name","msapplication-TileColor"],["content","#ffffff"]],[["name","msapplication-TileImage"],["content","/assets/icons/ms-icon-144x144.png"]],[["name","theme-color"],["content","#ffffff"]]]
  htmlTitle = "Practical Metaphysics and Harmonious Mana."
page = new how_can_hypnosis_help_me_with_romance_or_my_relationship
console.log T.render page.html
