# 
class reassuring_reasons_why_hypnosis_is_your_friend extends celarientemplate
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
      T.h1 => T.raw "Reassuring Reasons why Hypnosis is your Friend"
      T.hr()
      @bloviation()
  # 
  # section bloviation
  # 
  bloviation: =>
    T.div "#bloviation.contents", id: "bloviation", class: "contents", "dangerously-set-inner-h-t-m-l": "[object Object]", =>
      T.p =>
        T.em =>
          T.strong => T.raw "Jim’s Note"
          T.raw ": If you have even the slightest hesitation, either out of fear that it won’t work or fear that it will work too well, then you should read this:"
      T.p =>
        T.raw "For too long"
        T.a href: "http://www.hypnosisdownloads.com/?3034", target: "_blank", => T.raw "hypnosis"
        T.raw "has had a bad or ‘difficult’ press. If a person doesn’t understand something they have 3 options open to them."
      T.p => T.raw """
1) They might be sceptical and therefore save the trouble of looking further and possibly benefiting.
2) They may conclude it is dangerous and to be avoided at all costs.
3) They may spend time discovering the truth behind the hype.
"""
      T.p => T.raw "If you don’t know much about a topic it’s easy to be suspicious. Some people assume hypnosis is akin to a carnival side show, others consider it  mystic mumbo jumbo or ‘mind control.’  For those who look beyond the hype the truth is far more illuminating."
      T.p =>
        T.strong => T.raw "The most powerful tool you possess"
      T.p => T.raw "There are potentially huge benefits for those who use hypnosis as part of everyday life. When you understand hypnosis you start to see its potential to improve human performance in the physical, emotional and intellectual realms. For me, rumour, gossip and suspicion weren’t good enough."
      T.p => T.raw "I determined to learn all I could about hypnosis - I learned every fact and practised every technique under the sun. I took several training courses - some good, some terrible. I invested thousands of hours of devoted study to hypnosis and discovered just what is possible. I hypnotised friends, neighbours and work colleagues. Hypnosis greatly changed things for me on a personal level"
      T.p =>
        T.strong => T.raw "How hypnosis helped me"
      T.p => T.raw "I used to be shy. Thanks to hypnosis I can now talk to thousands at a time and can approach anybody calmly and confidently."
      T.p => T.raw "I used to have poor concentration and procrastinate; thanks to hypnosis I can instantly motivate myself."
      T.p => T.raw "I used to find physical work outs and exercise exhausting but because of hypnosis I am now in the best shape of my life."
      T.p => T.raw "Incidentally I also stopped myself blushing with hypnosis. Now if ever I have a difficult call or conversation coming up, something I may naturally feel reluctant to do (you know the kind of thing) I spontaneously self hypnotise and rehearse the upcoming situation feeling good, with myself remaining calm. In this way I habitually set my own emotional ‘blue prints’ for up coming situations. Having said that it’s naturally that some people have concerns or half digested ‘hand me down’ ideas regarding hypnosis. A common one is the one about ‘mind control.’ However what does this really mean?"
      T.p =>
        T.strong => T.raw "Why you are more in control of yourself in hypnosis"
      T.p => T.raw "If someone expresses concerns about being ‘controlled’ in hypnosis what they mean is they don’t want to be like a robot, an automaton that is forced to obey the every whim of the hypnotist. We can’t help but influence others but we don’t control them. To understand why you need to understand hypnosis better."
      T.p =>
        T.strong => T.raw "So what is hypnosis like?"
      T.p => T.raw "Hypnosis isn’t like a coma. It’s not unconsciousness - more a subtle shifting of consciousness. In hypnosis, you can still think logically but you also have access to the ‘software’ of your mind so that you can update instinctive emotional and physical responses. In fact the hypnotised subject (not the hypnotist) calls the shots. When I hypnotise someone I need to go at their speed and respond to their needs and expectations. Hypnosis will give you more control in your own life because of what it enables you to do."
      T.p =>
        T.strong => T.raw "How can I be so sure?"
      T.p => T.raw "Because over the decades I’ve seen all kinds of people, all ages and from all backgrounds turn their lives around thanks to hypnosis. When you use hypnosis for yourself it improves confidence in all kinds of ways. When you use it to change other’s lives it just blows you away. This is what I mean."
      T.p => T.raw "When I first hypnotised someone to feel no sensation in a painful arthritic arm it was an incredible feeling. When I first cured life long phobias quickly and comfortably I was astounded. When I stopped hardened alcoholics from drinking and even got a heroin addict off the stuff and back into mainstream life  again I started to feel angry that people could just associate hypnosis with entertainment."
      T.p => T.raw "With the aid of hypnosis I (and many people I have trained and worked with) have helped severely depressed people feel strong and positive again. The rewards and satisfactions are hard to describe. I’m going to take a stand against ignorance and short sightedness around hypnosis and here’s why."
      T.p =>
        T.strong => T.raw "Why you need to reclaim hypnosis for yourself"
      T.p => T.raw "Hypnosis is your birthright. It’s nature’s optimum learning tool. In fact to learn and perform anything well you need to experience a natural focussing of attention, a natural kind of hypnosis.  To be successful hypnosis needs to be your companion and friend."
      T.p => T.raw "Successful people use it naturally all the time because hypnosis is natural. It’s the way we learn new responses. Unlike medications its side effects are purely positive - one expectant mother I worked with to feel relaxed during child birth later reported that she was also more relaxed when flying!"
      T.p => T.raw "Hypnosis is easy to learn and every body can benefit. Hypnosis is a safe environment to ‘try out’ new behaviours and emotional patterns before you experience them for real. So the young man can ask a woman out for a date many times in calm relaxed hypnosis so that by the time he does it for real it feels real and natural and relaxed.  Sports people who use hypnosis learn new quicker and more accurately. So hypnosis gives you more control of yourself and your life, it’s natural and gives you instant benefits and it’s a way of ‘trying on’ and establishing new patterns of emotional response and behaviour, Hypnosis enables you to develop yourself as a human being."
      T.p =>
        T.raw "HypnosisDownloads.com offer a free course called ‘"
        T.a href: "http://www.hypnosisdownloads.com/learn_hypnosis.html?3034", => T.raw "Learn Hypnosis in 5 Days"
        T.raw "‘."
      T.p =>
        T.raw "Article by Mark Tyrrell of"
        T.a href: "http://www.hypnosisdownloads.com/?3034", => T.raw "Hypnosis Downloads.com."
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
page = new reassuring_reasons_why_hypnosis_is_your_friend
console.log T.render page.html
