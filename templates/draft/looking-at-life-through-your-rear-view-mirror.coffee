# 
class looking_at_life_through_your_rear_view_mirror extends celarientemplate
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
      T.h1 => T.raw "Looking At Life Through Your Rear View Mirror"
      T.hr()
      @bloviation()
  # 
  # section bloviation
  # 
  bloviation: =>
    T.div "#bloviation.contents", id: "bloviation", class: "contents", "dangerously-set-inner-h-t-m-l": "[object Object]", =>
      T.p =>
        T.em =>
          T.strong => T.raw "Jim’s Note:"
          T.raw "As I reviewed this note for publication, I was reminded of a truth that I have not written much about:  Love is a verb, and verbs can be past, present or future:  When we have love for the past, it is"
          T.strong => T.raw "reverence"
          T.raw ",  Love of the present is"
          T.strong => T.raw "compassion"
          T.raw ",  and love of the future is expressed through"
          T.strong => T.raw "wisdom"
          T.raw ".  This note from"
          T.strong => T.raw "Andy Cox"
          T.raw "may help us transform our view of the past into a view of reverence:  we had to go through everything that came before so that we can be who we are today."
      T.h3 => T.raw "Looking At Life Through Your Rear View Mirror"
      T.p => T.raw "Many of us spend a significant amount of time looking through the rear view mirrors of our lives. Some people spend all their time there - some spend no time there - but most have a nice balance between looking at what’s behind and what’s ahead."
      T.p => T.raw "Sometimes the “mirror” can be really helpful, and sometimes it can cough up those really embarrassing, stupid, negative memories that are best forgotten, but that the mirror wants to keep front and center."
      T.p => T.raw "Have you ever had the experience of suddenly being confronted, in your mind, with something you did in the past that you wish you hadn’t, or that you regretted, and that “something” flashes up on your brain screen and sends a chill down your spine, or a flop to your stomach, or a tear to your eye - or a song to your heart?"
      T.p => T.raw "Funny - very few of my rear view mirror flashes send a song to my heart. I don’t know about you, but my mirrors tend to be critical of my behavior - the coulda’, woulda’, shoulda’s that make me feel less good about myself. My rear view mirror wants to keep the negative stuff more available than the “bring a smile” stuff."
      T.p => T.raw "I’m talking about those little drops of negative emotional water that hit your brain, again and again, and in so doing create a groove or funnel for continued negative flashes."
      T.p => T.raw "What these flashes do is create habits of thought that affect our beliefs about our personal worth, ability and value. And those negative mirror flashes feed those two little worms - the “I am not worthy” one, and the “I am not able” one. And they grow. And we do it to ourselves."
      T.p => T.raw "The most powerful messages we receive about our ability and value are the ones we send ourselves. And we’re often not aware that we’re even doing it. That’s the thing about habits - both good and bad. They become so ingrained that we just do them. The good news is habits can be changed. Not stopped, but replaced with other habits."
      T.p => T.raw "If your rear view mirror keeps sending you negative messages about your past, here are suggestions on ways to change that destructive habit of thought."
      T.ol =>
        T.li => T.raw "Be aware that it is happening. That sounds so obvious, but habits are sneaky. They get so ingrained that they seem unconscious. The first step is to challenge your thoughts. Are they helpful? Are they destructive? Do they help or hinder?"
        T.li => T.raw "Prepare a list of the top 100 things that make you smile, make you feel thankful, make you proud, make you feel worthy and able. Write them down. This can be tough - especially if your messages have been negative for a long time. But it is the key step to replacing those negative thoughts."
        T.li => T.raw "Review them every day and add to them as you think of more positive messages."
        T.li => T.raw "When a negative thought message comes through, catch yourself and tell yourself to stop! And then replace it with one of your 100 or more “guaranteed to make you feel good about yourself” messages you have written down."
        T.li => T.raw "Persist. Habits take time and dedication to change. Keep reminding yourself of the value of thinking positively about yourself. And of how much better it makes you feel."
        T.li => T.raw "Think of your rear view mirror as having two modes - one that lets in all the bright lights that can blind you, and the other mode that filters so you can see more clearly."
      T.p => T.raw "Let’s face it, life has and will continue to throw all kinds of challenges at us. Using your rear view mirror to prepare for the challenges to be faced is a powerful habit of thought. Take a look in yours right now, and become aware of what a positive tool it can be."
      T.hr()
      T.p =>
        T.raw "Andy Cox helps his clients select and develop teams and talent. He focuses on helping leaders and emerging leaders define and develop their skills and talents using goals. He can be reached at"
        T.a href: "http://www.coxconsultgroup.com", => T.raw "http://www.coxconsultgroup.com"
        T.raw """
, or at acox@coxconsultgroup.com
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
page = new looking_at_life_through_your_rear_view_mirror
console.log T.render page.html
