<script>
</script>

<template lang="pug">
#header.grid
  d
    a.sm-hide.xs-hide.pt4.pl2.col-3.self-bottom(href='/')
      img.circle(style='-moz-transform:scaleX(-1);-o-transform:scaleX(-1);-webkit-transform:scaleX(-1);transform:scaleX(-1);filter:FlipH;-ms-filter:FlipH', src='https://www.gravatar.com/avatar/c105eda1978979dfb13059b8878ef95d?s=120')
  .col-6.white(height='250px')
    h1.center.white 411-source
    h2.center.white If You Can't Find It, it may not be here...
  a.pt4.pr2.col-3(href='/')
    img.circle(src='https://www.gravatar.com/avatar/c105eda1978979dfb13059b8878ef95d?s=120')

</template>

<style>
.center {
  text-align: center;
}
.white {
  color: #fff;
  text-shadow: 1px 2px 3px #762;
}
#header {
  background: #eee;
  min-height:30px;
  background:center 32% no-repeat url(/images/banner.jpg);
  padding: 1rem;
  grid-area: Header;
  grid-template-columns: 1fr 2fr 1fr;
  align-content: center;
  grid-auto-flow: column;
  justify-content: center;
  }

.circle {
border-radius:45%;
}
</style>
