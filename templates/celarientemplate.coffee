# 
T = require 'halvalla'
module.exports = class celarientemplate
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
      T.h1 => T.raw "The Myth Of A Christian Soul Mate"
      T.hr()
      @bloviation()
  # 
  # section bloviation
  # 
  bloviation: =>
    T.div "#bloviation.contents", id: "bloviation", class: "contents", "dangerously-set-inner-h-t-m-l": "[object Object]", =>
      T.p =>
        T.em =>
          T.strong => T.raw "Jim’s note:"
          T.raw "This article caught my Celarien® eye!  I really like it.  Even though Christianity is not a single, orthodox, catholic religion, there being lots of protestation on the subject: the selected author’s idea of choice, soulmate and a divine organization behind all of that ring true with the essence of the spirituality of Celarien:  That you can choose and learn and grow.  Choosing to learn to grow in love with your partner is all about removing those blocks to that love: the essence of Celarien’s spiritual message.  That you are not stuck, not fixed for all eternity."
      T.p =>
        T.em =>
          T.raw "Christians, and everyone of a religious or spiritual core, want most of all to have a strong and vibrant relationship with the spirit of the universe: God.  Now consider this: you have a partner with that inner spirit: that soul essence that eludes scientific or mathematical description.  It is like God sent you a pertner that are like"
          T.strong => T.raw "trainer wheels."
          T.raw "To learn to grow to have a strong and vibrant relationship with God, you can start with growing to love your partner as your soul mate!"
      T.p =>
        T.em => T.raw "The Celarien Experience® is happy to present you with this article by Jay White"
      T.p => T.raw """
Catch phrases are a part of everyday society. They become hugely popular, ride a wave of cultural phenomenon, than seem to disappear as quickly as they came.
But there’s a term that was introduced years ago and still hasn’t dropped from the vocabulary, even in Christian dating circles. Whenever there’s a conversation about relationships, it always seems to pop out of somewhere.
"""
      T.p => T.raw "That term is “soul mate”."
      T.p => T.raw "Read romance novels. Listen to popular love songs. Watch movies on Lifetime television, and chances are “soul mate” will be uttered in some way, shape or form."
      T.p => T.raw "In fact, entire stories have spawned from the idea of a soul mate. Ever see “Sleepless in Seattle”? You get the picture."
      T.p => T.raw "But I’m here to tell you something that may not be popular, but I sincerely believe it’s the truth:"
      T.p => T.raw "There’s no such thing as a soul mate."
      T.p => T.raw "Now, before you gasp and go storming away from your computer, consider the premise of “Sleepless in Seattle”."
      T.p => T.raw "A perfectly happy woman, engaged to a man she loves, spends most of her time lamenting the fact that she may have missed out on someone better. Of course, we’re led to believe her true “soul mate” lives 3,000 miles away and doesn’t know her from Adam. Yet, destiny and fate must have their way, and incredible circumstances bring them to the climactic scene on top of the Empire State Building, where the two strangers lock eyes and know instantly that they are to be together forever. Fade to black, roll credits…"
      T.p => T.raw "…and hand me a barf bag!"
      T.p => T.raw "Don’t get me wrong–I can dig a chick movie now and then. But to buy into the soul mate theory goes completely against what God wants for us in a relationship."
      T.p => T.raw "For example, my wife and I believe 100% that God brought us together. I am completely and totally in love with my wife."
      T.p => T.raw "Does that mean I could never love another? Nope. I could fall in love with someone else if I wanted. I could crush everything we’ve built and separate myself from my family."
      T.p => T.raw "But I CHOOSE not to."
      T.p => T.raw "And that’s the key. Real love is not at-first-sight, violins-and-bluebirds baloney. It’s a choice. Plain and simple."
      T.p => T.raw "Destiny hasn’t preordained our lives, God has. But He’s also given us free will in the matter. Just like we make the choice between serving God or serving ourselves, we also choose whether or not to love someone."
      T.p => T.raw "But according to popular culture and the media, you don’t have a choice. You must search for your one-and-only soul mate. Get all swept up in the romance. Don’t be concerned with the real world."
      T.p => T.raw "And that’s what gets a lot of people in trouble. They start believing the hype instead of believing the Truth. Before you know it, they’re throwing away a perfectly healthy relationship for a fantasy. In fact, it’s my personal belief that a large factor in the demise of traditional family values is the proliferation of such anti-Christian ideas, such as a soul mate, through the media."
      T.p => T.raw "If I buy into the notion of a soul mate, then I believe destiny has preordained just one person for me. Only one. Anyone else would obviously make me unhappy and unfulfilled. After all, it’s been laid out for me already. I have no choice."
      T.p => T.raw "Wrong!"
      T.p => T.raw "What if I lost my wife tragically? I would hope that the Lord would bring someone for me to marry again in time, but if Ronda was my “soul mate”, then what would that make my second wife–”soul mate part 2”?"
      T.p => T.raw "See what am I getting at here?"
      T.p => T.raw "God has a perfect mate for you and will help you find them. But He can’t make you love them. That’s up to you."
      T.p => T.raw "For example, we have friends who spent their lives on the mission field. The wife will flat-out tell you that she did not love her husband when she married him. But she knew God wanted them to be together, so she grew to love him over the years and never looked back."
      T.p => T.raw "Now THAT’s faith!"
      T.p => T.raw "Do yourself a favor–turn off the tube. Throw away those trashy novels. Stop listening to those sappy love songs and dig into the Word! Jesus said “I am the Way, the Truth and the Life.” He had a plan for me and he has a plan for you. Talk with Him, listen to Him, and He’ll lead the way."
      T.p => T.raw "And when you do find that special someone, you’ll know that it’s not destiny that brought you together, but His good and perfect will."
      T.p => T.raw "So take that Meg Ryan and Tom Hanks!"
      T.p =>
        T.hr()
      T.p =>
        T.raw "Jay White is an author, copywriter, and former Christian single who knows the struggles and frustrations of Christian dating. For more information on how you can find God’s perfect mate for you, go to"
        T.a href: "http://www.christianonlinedatingsecrets.com", => T.raw "http://www.christianonlinedatingsecrets.com"
      T.p =>
        T.raw "Article source:"
        T.a href: "http://www.goarticles.com/", => T.raw "http://www.goarticles.com/"
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
