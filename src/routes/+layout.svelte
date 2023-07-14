<script>
// src/routes/+layout.svelte
let styling = {"palx":"#03c","black":"#000","white":"#fff"};
import allStories from './allstories.json';
import stories from './mystories.json?raw';
import Footer from './Footer.svelte';
import Aside from './Aside.svelte';
import Header from './Header.svelte'
let siteHandle = '411-source';
let topDomain = '411-source.com'; 

</script>

<template lang="pug">
svelte:head
  base(href='/')
  meta(name='author', content='James A. Hinds: The Celarien\'s best friend.  I\'m not him, I wear glasses')
  meta(http-equiv='Content-Type', content='text/html', charset='UTF-8')
  meta(name='viewport', content='width=device-width,initial-scale=1')
  title Practical Metaphysics and Harmonious Mana.
  meta(name='description', content='some good thoughts. Maybe.')
  meta(name='keywords', content='romance, wisdom, tarot')
  link(rel='apple-touch-icon', sizes='57x57', href='/assets/icons/apple-icon-57x57.png')
  link(rel='apple-touch-icon', sizes='60x60', href='/assets/icons/apple-icon-60x60.png')
  link(rel='apple-touch-icon', sizes='72x72', href='/assets/icons/apple-icon-72x72.png')
  link(rel='apple-touch-icon', sizes='76x76', href='/assets/icons/apple-icon-76x76.png')
  link(rel='apple-touch-icon', sizes='114x114', href='/assets/icons/apple-icon-114x114.png')
  link(rel='apple-touch-icon', sizes='120x120', href='/assets/icons/apple-icon-120x120.png')
  link(rel='apple-touch-icon', sizes='144x144', href='/assets/icons/apple-icon-144x144.png')
  link(rel='apple-touch-icon', sizes='152x152', href='/assets/icons/apple-icon-152x152.png')
  link(rel='apple-touch-icon', sizes='180x180', href='/assets/icons/apple-icon-180x180.png')
  link(rel='icon', type='image/png', sizes='192x192', href='/assets/icons/android-icon-192x192.png')
  link(rel='icon', type='image/png', sizes='32x32', href='/assets/icons/favicon-32x32.png')
  link(rel='icon', type='image/png', sizes='96x96', href='/assets/icons/favicon-96x96.png')
  link(rel='icon', type='image/png', sizes='16x16', href='/assets/icons/favicon-16x16.png')
  link(rel='manifest', href='/assets/manifest.json')
  meta(name='msapplication-TileColor', content='#ffffff')
  meta(name='msapplication-TileImage', content='/assets/icons/ms-icon-144x144.png')
  meta(name='theme-color', content='#ffffff')
  link(rel='shortcut icon', href='assets/icons/favicon.ico', type='image/x-icon')
  link(rel='icon', href='assets/icons/favicon.ico', type='image/x-icon')

div.fixed
#celarien-body.container-fluid.bg-transparent
  .siteContainer
    Header#header.d-flex.d-row.justify-content-around.align-items-center.w-100(style='height:250px')

  .site(style='min-height:100vh')
    #storybar.mainly
      slot
    Aside#sidebar({stories} style='min-width:240')
  Footer
  #cover.fixed

</template>

<style>
  @import "@picocss/pico";
  .sitecontainer {
    padding: 0.1in;
    display: flex;
    flex-direction: column;
    height: auto;
    width: 100vw;
  }
  .mainly {
    grid-area: Main;
    padding: 0 2em 0 0;
  }
  .site {
    display: grid;
    gap: 5em 0em;
    grid-template-columns: 1fr 5fr 2fr;
    grid-template-areas: "None Main Aside";
    min-height: 100vh;
  }
#cover {
top: 0;
left: 0;
position: fixed;
background-repeat: no-repeat;
background-size: cover;
z-index: -1;
height:100%;
width:100%;
}
.fixed {
background: url(images/hooray-fade2.jpg) no-repeat center fixed;
-moz-transform:scaleX(-1);
-o-transform:scaleX(-1);
-webkit-transform:scaleX(-1);
transform:scaleX(-1);
filter:FlipH;
ms-filter:FlipH
}
</style>
