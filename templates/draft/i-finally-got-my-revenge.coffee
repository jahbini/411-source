# 
class i_finally_got_my_revenge extends celarientemplate
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
      T.h1 => T.raw "I Finally Got My Revenge!"
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
          T.raw "Revenge is the act or thought of bringing someone down because of a real or potential harm to oneself.  Revenge is not an element of Celarien®, in fact, it is all about letting go of  that: for any reason.  Michael A. Verdicchio has a great tale of achievement after many years, and is  a model for us to look up to.  Even so, I wonder if Earl, of Television’s"
          T.strong => T.raw "My Name is Earl"
          T.raw ", would put this firing on his list to fix.  Admittedly, Christians never consider themselves free of sin, only saved from it."
      T.h2 => T.raw "I Finally Got My Revenge!"
      T.p => T.raw "It took me six months.  The anger and betrayal was finally satisfied on that humid day in June…or was it?  It was the day I finally got my revenge.  It happened over thirty years ago."
      T.p => T.raw "Six months earlier, I accepted a job in Florida.  My new bride of eight months and I moved to the beautiful panhandle of the Sunshine State.  It was a modest increase in pay from where I was before."
      T.p => T.raw "We lived three blocks from the beach and paid one hundred dollars a month to rent a one bedroom house.  I was hired to do the afternoon show on a local radio station.  Everything seemed wonderful."
      T.p => T.raw """
But then, scarcely two weeks after we arrived, he pulled his stunt.  The man who hired me, the man who was my boss, the program director of the radio station, propositioned my wife! I’m not talking about flirting, or making a pass, or innuendoes.  This man offered her a very discreet intimate
relationship!  He hardly knew her!  This was my wife!  Did I mention that he was also married, and the recent father of twins?
"""
      T.p => T.raw "When my wife Kathy told me what had happened, I was so furious that I wanted to go and shoot him on the spot!  I’m not kidding!  Thank God I decided against that plan."
      T.p => T.raw "I did however get some good advice from my landlord.  Mac was a kind middle-aged man who seemed generally concerned about helping this 21 year old who was really upset.  And, this was an interesting situation."
      T.p => T.raw "He was my boss.  He had hired me.  He could fire me.  Maybe I should just quit."
      T.p => T.raw "Mac suggested that I confront him on the telephone, which I did.  I told him that Kathy had told me everything.  I also told him in no uncertain terms that I did not want him to even speak to my wife ever again."
      T.p => T.raw "So, now, I had to see him every day at work.  He would usually leave around 1 p.m. but I would get there around 11 a.m.  He apologized to me every single day.  I never accepted it.  I kept saying, “Just forget it, okay?”  However, I was certainly not forgetting about it."
      T.p => T.raw "As the days and weeks went by, my anger continued to grow. Then, conflicts began to arise between the two of us over work related matters.  The tension grew until one day I was called in early to the general manger’s office."
      T.p => T.raw "The general manger then informed me that he was making some changes and that I was now going to be the program director.  “That’s great,” I said, “And, what about Mr. So and So?”  He said, “Well, that’s up to you; you’re in charge now.”"
      T.p => T.raw "I thought to myself, “At last, at last, I will get my revenge!”  I looked at the general manager and said, “He’s gone!”  I got up and walked out of his office, met the man I had grown to hate, and said, “Get your stuff and get out - you’re fired!”"
      T.p => T.raw "I felt so proud of myself!  He finally got what he deserved!  I even bragged about the whole event for a number of years.  But, I was never truly free of the anger until I forgave him.  And yes, there came a day when I really did forgive him."
      T.p => T.raw "I remember a Bible teacher saying, “You’ll have no problem forgiving others if you just remember what God forgave you for.”  Wow!  Isn’t that true?  I know I’ve certainly made my share of mistakes."
      T.p => T.raw "So, finally one day, I honestly forgave the man from my heart for what he had done.  I wasn’t excusing his actions, or saying that what he did wasn’t wrong; I was simply forgiving him."
      T.p => T.raw "And then, I noticed a remarkable thing.  All that anger against him that I had been carrying around for all those years was gone.  Prior to that, at those times when I brought up the event in my life, the same anger was there, just as fierce as ever."
      T.p => T.raw "But now, even as I write this article, I have no anger.  I have no emotions tied to it at all.  You see, revenge didn’t quell my anger, forgiveness did.  And I never realized that by keeping all that anger inside me, I was allowing him to continue to affect my life!  I was allowing him to have power over me.  I was not in control!"
      T.p => T.raw "Very few people understand how freeing it is to forgive.  To simply and completely let go and dismiss what someone has done to you without wanting or desiring any penalty for what they have done will release you."
      T.p => T.raw "We have all been forgiven, many times over.  So, why not forgive others?"
      T.hr()
      T.p =>
        T.raw "Michael A. Verdicchio offers a free 71 page eBook, entitled, “"
        T.a href: "http://www.EnrichingYourLifeNow.com", => T.raw "Keys To Enriching Your Life Now!"
        T.raw """
“ at
"""
        T.a href: "http://www.EnrichingYourLifeNow.com", => T.raw "http://www.EnrichingYourLifeNow.com"
        T.raw "He has a free newsletter called,"
        T.a href: "http://www.christianinspirationalgifts.com/pepletter.html", => T.raw "THE PEP LETTER"
        T.raw """
, at
"""
        T.a href: "http://www.christianinspirationalgifts.com/pepletter.html", => T.raw "http://www.christianinspirationalgifts.com/pepletter.html"
      T.p => T.raw "Michael is a husband, father, minister, author, and broadcaster. He has been the voice on numerous projects and productions over the years, including Mike’s Pep Talks."
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
page = new i_finally_got_my_revenge
console.log T.render page.html
