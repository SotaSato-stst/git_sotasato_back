<template>
  <div class="default-layout">
    <nuxt />
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
export default Vue.extend({
  name: 'DefaultLayout',
  props: {},
  data() {
    return {}
  },
  computed: {},
})
</script>

<style>
/* bodyにuser agent stylesheetによってmarginが入ってしまうため */
body {
  margin: 0;
  color: var(--main-text-color);
}
</style>

<style lang="postcss" scoped>
.default-layout {
  background-color: var(--background-color);
}
</style>
