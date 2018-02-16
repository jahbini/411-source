# 
class laboratory_experiments_with_subliminal_messages extends celarientemplate
  # 
  # section html
  # 
  html: =>
    T.doctype 'html'
    T.html =>
      T.head =>
        T.base href: "/"
        T.meta name: "author", content: "James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"
        T.meta "http-equiv": "Content-Type", content: "text/html", charset: "UTF-8"
        T.meta name: "viewport", content: "width=device-width, initial-scale=1"
        T.title => T.raw "Practical Metaphysics and Harmonious Mana."
        T.meta name: "description", content: "some good thoughts. Maybe."
        T.meta name: "keywords", content: "romance, wisdom, tarot"
        T.meta property: "fb:admins", content: "1981510532097452"
        T.script """
// This is called with the results from from FB.getLoginStatus().
function statusChangeCallback(response) {
//console.log('statusChangeCallback');
//console.log(response);
// The response object is returned with a status field that lets the
// app know the current login status of the person.
// Full docs on the response object can be found in the documentation
// for FB.getLoginStatus().
if (response.status === 'connected') {
  // Logged into your app and Facebook.
  testAPI();
} else {
  // The person is not logged into your app or we are unable to tell.
  document.getElementById('fb-status').innerHTML = 'Please log ' +
    'into this app.';
}
}

// This function is called when someone finishes with the Login
// Button.  See the onlogin handler attached to it in the sample
// code below.
function checkLoginState() {
FB.getLoginStatus(function(response) {
  statusChangeCallback(response);
});
}

window.fbAsyncInit = function() {
FB.init({
appId      : '1981510532097452',
cookie     : true,  // enable cookies to allow the server to access 
                    // the session
xfbml      : true,  // parse social plugins on this page
version    : 'v2.8' // use graph api version 2.8
});

// Now that we've initialized the JavaScript SDK, we call 
// FB.getLoginStatus().  This function gets the state of the
// person visiting this page and can return one of three states to
// the callback you provide.  They can be:
//
// 1. Logged into your app ('connected')
// 2. Logged into Facebook, but not your app ('not_authorized')
// 3. Not logged into Facebook and can't tell if they are logged into
//    your app or not.
//
// These three cases are handled in the callback function.

FB.getLoginStatus(function(response) {
statusChangeCallback(response);
});

};

// Load the SDK asynchronously
(function(d, s, id) {
var js, fjs = d.getElementsByTagName(s)[0];
if (d.getElementById(id)) return;
js = d.createElement(s); js.id = id;
js.src = \"//connect.facebook.net/en_US/sdk.js\";
fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

// Here we run a very simple test of the Graph API after login is
// successful.  See statusChangeCallback() for when this call is made.
function testAPI() {
//console.log('Welcome!  Fetching your information.... ');
FB.api('/me', 'get', {'fields':'first_name,gender'}, function(response) {
  //console.log('Successful login for: ', response);
  $('.FBname').text(response.first_name);
  document.getElementById('fb-status').innerHTML =
    'Thanks for logging in, ' + response.first_name + '!';
});
}
"""
        T.script "document.styling = {\"palx\":\"#03c\",\"black\":\"#000\",\"white\":\"#fff\"}"
        T.link rel: "apple-touch-icon", sizes: "57x57", href: "/assets/icons/apple-icon-57x57.png"
        T.link rel: "apple-touch-icon", sizes: "60x60", href: "/assets/icons/apple-icon-60x60.png"
        T.link rel: "apple-touch-icon", sizes: "72x72", href: "/assets/icons/apple-icon-72x72.png"
        T.link rel: "apple-touch-icon", sizes: "76x76", href: "/assets/icons/apple-icon-76x76.png"
        T.link rel: "apple-touch-icon", sizes: "114x114", href: "/assets/icons/apple-icon-114x114.png"
        T.link rel: "apple-touch-icon", sizes: "120x120", href: "/assets/icons/apple-icon-120x120.png"
        T.link rel: "apple-touch-icon", sizes: "144x144", href: "/assets/icons/apple-icon-144x144.png"
        T.link rel: "apple-touch-icon", sizes: "152x152", href: "/assets/icons/apple-icon-152x152.png"
        T.link rel: "apple-touch-icon", sizes: "180x180", href: "/assets/icons/apple-icon-180x180.png"
        T.link rel: "icon", type: "image/png", sizes: "192x192", href: "/assets/icons/android-icon-192x192.png"
        T.link rel: "icon", type: "image/png", sizes: "32x32", href: "/assets/icons/favicon-32x32.png"
        T.link rel: "icon", type: "image/png", sizes: "96x96", href: "/assets/icons/favicon-96x96.png"
        T.link rel: "icon", type: "image/png", sizes: "16x16", href: "/assets/icons/favicon-16x16.png"
        T.link rel: "manifest", href: "/assets/manifest.json"
        T.meta name: "msapplication-TileColor", content: "#ffffff"
        T.meta name: "msapplication-TileImage", content: "/assets/icons/ms-icon-144x144.png"
        T.meta name: "theme-color", content: "#ffffff"
        T.link rel: "stylesheet", href: "assets/css/vendor.css", "-content--encoding": "gzip"
        T.link rel: "stylesheet", href: "https://unpkg.com/blaze", "-content--encoding": "gzip"
        T.link rel: "stylesheet", href: "assets/css/app.css", "-content--encoding": "gzip"
        T.link rel: "shortcut icon", href: "assets/icons/favicon.ico", type: "image/x-icon"
        T.link rel: "icon", href: "assets/icons/favicon.ico", type: "image/x-icon"
        T.script src: "api/allstories"
        T.script src: "api/mystories"
        T.script src: "assets/js/vendor.js", "-content--type": "text/javascript", "-content--encoding": "gzip"
        T.script src: "assets/js/app.js", "-content--type": "text/javascript", "-content--encoding": "gzip"
        T.script "siteHandle = 'celarien'; topDomain = 'celarien.com'; require('initialize');"
      T.body =>
        @celarien_body()
  # 
  # section celarien_body
  # 
  celarien_body: =>
    T.div "#celarien-body.c-text.o-grid.o-grid--full", id: "celarien-body", class: "c-text o-grid o-grid--full", =>
      T.div ".style.c-hero", class: "style c-hero", style: "{ border-bottom: 1px solid #333; }"
      T.div ".c-hero.o-grid__cell.u-higher", class: "c-hero o-grid__cell u-higher", =>
        @header()
      T.div ".o-grid__cell", class: "o-grid__cell", style: "min-height:100vh", =>
        T.div ".o-grid", class: "o-grid", =>
          @storybar()
          @sidebar()
          @sidecar()
      @footer()
      @cover()
  # 
  # section cover
  # 
  cover: =>
    T.div "#cover", id: "cover", style: "background-image:url(/assets/images/hooray-fade2.jpg);-moz-transform:scaleX(-1);-o-transform:scaleX(-1);-webkit-transform:scaleX(-1);transform:scaleX(-1);filter:FlipH;ms-filter:FlipH"
  # 
  # section footer
  # 
  footer: =>
    T.div "#footer.panel", id: "footer", class: "panel", bg: "white", =>
      T.h2 => T.raw "All contents copyright 2015, James A. Hinds"
      T.p => T.raw "The ideas are yours to keep and share, the wording is mine."
  # 
  # section sidecar
  # 
  sidecar: =>
    T.div "#sidecar.o-grid__cell.o-grid__cell--width-fixed.order-last.bg-darken-2", id: "sidecar", class: "o-grid__cell o-grid__cell--width-fixed order-last bg-darken-2", style: "min-width:240", =>
      T.div ".fb-login-button", class: "fb-login-button", width: "200", "data-width": "200", "data-max-rows": "1", "data-size": "medium", "data-button-type": "login_with", "data-show-faces": "true", "data-auto-logout-link": "true", "data-use-continue-as": "true"
      @fb_status()
  # 
  # section fb_status
  # 
  fb_status: =>
    T.div "#fb-status", id: "fb-status"
  # 
  # section sidebar
  # 
  sidebar: =>
    T.aside "#sidebar.o-grid__cell.o-grid__cell--width-20.p2.bg-darken-2", id: "sidebar", class: "o-grid__cell o-grid__cell--width-20 p2 bg-darken-2", style: "min-width:240"
  # 
  # section storybar
  # 
  storybar: =>
    T.div "#storybar.o-grid__cell.order-2.bg-lighten-2", id: "storybar", class: "o-grid__cell order-2 bg-lighten-2", =>
      T.h1 => T.raw "Laboratory Experiments With Subliminal Messages"
      T.hr()
      @bloviation()
  # 
  # section bloviation
  # 
  bloviation: =>
    T.div "#bloviation.contents", id: "bloviation", class: "contents", "dangerously-set-inner-h-t-m-l": "[object Object]", =>
      T.p =>
        T.em => T.raw "Jim’s Note:"
        T.em => T.raw "The evidence for subliminal messages is mixed.  It may have an effect on our attitudes and behavior, but the laboratory may never really give us the answer.  Check it out and evaluate for yourself.  Can there be more direct and efficient methods for you to get control of your world?  I am opening up comments on this page so you can let me know your ideas and experiences."
      T.p => T.raw "Submitted By:Michael McGrath"
      T.p =>
        T.a href: "http://hypnosis.personal-development.info/", => T.raw "http://hypnosis.personal-development.info"
      T.p => T.raw """
Do subliminal messages really work? Can your brain even
record messages that you are consciously unaware of? This
is a debate that has been raging since the 1950s and
recently we have some scientific evidence to give us the
answer!
"""
      T.p => T.raw """
A neuroscientist at the Institute of Cognitive Neuroscience
University College London, called Bahador Bahrami, has
found through laboratory experiments that subliminal
messages do indeed leave an impression on the brain. Using
sophisticated equipment Bahrami’s team of scientists
discovered that the brain is aware of, and records, images
that we are consciously not aware are there.
"""
      T.p => T.raw """
Bahrami had a group of volunteers view a computer screen
while wearing 3-D type glasses. One lens was coloured red
while the other was coloured blue. While some images where
shown to one eye that were faint, the other was subjected
to fast flashing vibrant images. As the vibrant images were
shown rapidly the subjects did not realize that there was
other faint images being shown.
"""
      T.p => T.raw """
Although the subjects were unaware that two images were
being shown it was found through MRI brain scanning that
the subliminal messages (faint images) were registered by
the brain.
"""
      T.p => T.raw """
Although there has long been debate over the effectiveness
of subliminal messages and especially subliminal
advertising this study has provided evidence for the
ability of subliminal messages to affect the brain.
Subliminal messages do get through even when we are unaware
that they are there.
"""
      T.p => T.raw """
The scientists found that when participants performed
routine or easy tasks the subliminal messages had a greater
impact than if they had to perform tasks that took more
concentration. They concluded that if there is spare
attention capacity in the brain then the brain allocates
that resource to the subliminal messages.
"""
      T.p => T.raw """
Bahador Bahrami has openly commented that subliminal
advertising and the subliminal messages that they contain
probably is recorded by the brain!
"""
      T.p => T.raw """
This can be easy to understand when we consider that
subliminal messages in advertising would be shown on TV or
in magazines when we are not using the full resources of
our brain or our attention!
"""
      T.p => T.raw """
The scientific team plan to conduct further studies into
the use of subliminal messages to determine just how
affective it is at influencing our buying habits. Bahrami
also plans on investigating how words affect the brain when
they are presented as subliminal messages.
"""
      T.p => T.raw """
So what does this study mean to those interested in the
self improvement aspects of subliminal messages?
"""
      T.p => T.raw """
As can be seen from this study subliminal messages are
recorded by the brain when we have spare attention
capacity. Anytime we perform routine or easy tasks we are
in such a state. Only when we are performing something that
requires heightened attention would we be immune to the
effects of subliminal messages because our attention is
diverted from the subliminal messages (even though were
don’t know they are there).
"""
      T.p => T.raw """
This is one reason why many people use subliminal messages
that flash on a computer screen. This is probably also the
reason why some self improvement audio subliminal messages
programs come with brain entrainment tones. These tones
force the brain to display alpha brainwaves which relax the
mind and body and would free up the attention resources of
the brain allowing the subliminal messages to be registered.
"""
      T.p => T.raw """
Through the use of recording techniques subliminal messages
can now be produced in a way that focuses your attention on
something that you are not even aware is there! It will be
very interesting to read the results of the next
experiments to be carried out at the Institute of Cognitive
Neuroscience University College London to see, once and for
all, just how affective subliminal messages are!
"""
      T.p =>
        T.a href: "http://www.personal-development.info/subliminals.html", => T.raw "http://www.personal-development.info/subliminals.html"
        T.raw """
-
We test and then review the best Subliminal products
available on the web. Find out what really works!
"""
        T.a href: "http://www.personal-development.info/subliminal_power.html", => T.raw "http://www.personal-development.info/subliminal_power.html"
      T.ul =>
        T.li => T.raw """
Read the review of the best Subliminal Messages
computer software we tested. Chose your subliminal messages
or write your own. We find out what works so you don’t have
to!
"""
  # 
  # section header
  # 
  header: =>
    T.header "#header.o-grid.o-grid--bottom", id: "header", class: "o-grid o-grid--bottom", style: "height:250px", =>
      T.div ".o-grid__cell.o-grid__cell--width-30", class: "o-grid__cell o-grid__cell--width-30", =>
        T.h3 =>
          T.a ".fa.fa-home", class: "fa fa-home", href: "/", => T.raw "Home"
        T.h3 =>
          T.a ".fa.fa-join", class: "fa fa-join", href: "/join", => T.raw "Join"
        T.div ".c-avatar.u-super", class: "c-avatar u-super", =>
          T.img ".c-avatar__img", class: "c-avatar__img", style: "-moz-transform:scaleX(-1);-o-transform:scaleX(-1);-webkit-transform:scaleX(-1);transform:scaleX(-1);filter:FlipH;ms-filter:FlipH", src: "http://www.gravatar.com/avatar/c105eda1978979dfb13059b8878ef95d?s=90"
  allMeta = [[["name","author"],["content","James A. Hinds: The Celarien's best friend.  I'm not him, I wear glasses"]],[["http-equiv","Content-Type"],["content","text/html"],["charset","UTF-8"]],[["name","viewport"],["content","width=device-width, initial-scale=1"]],[["name","description"],["content","some good thoughts. Maybe."]],[["name","keywords"],["content","romance, wisdom, tarot"]],[["property","fb:admins"],["content","1981510532097452"]],[["name","msapplication-TileColor"],["content","#ffffff"]],[["name","msapplication-TileImage"],["content","/assets/icons/ms-icon-144x144.png"]],[["name","theme-color"],["content","#ffffff"]]]
  htmlTitle = "Practical Metaphysics and Harmonious Mana."
page = new laboratory_experiments_with_subliminal_messages
console.log T.render page.html
