<script>
  export const identifier = "aside";
  export let stories;
  import _ from 'underscore';
  let info = _.groupBy(JSON.parse(stories),'category');
  delete info['-'];
  info = _.toArray(info);
</script>

<div class="aside">
  {#each info as category,indexx}
  <details>
  <summary>{info[indexx][0].category}</summary>
  <ul>
  {#each info[indexx] as story}
  <li>  <a href="{story.category}/{story.slug}" >{story.title}</a></li>
  {/each}
  <ul>
  </details>
  {/each}
<template lang="pug">
  button
    a(href="mailto:gimobeamo@spacestruts.com?subject=I want to know more&") Contact Us
</template>

</div>


<style>
  a {
    color: black;
  }

  .aside {
    background-color: beige;
    border-radius: 4px;
    padding: 1rem;
    grid-area: Aside;
  }
</style>
