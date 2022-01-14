<template>
  <div class="container">
    <div class="list">
      <default-banner />
      <default-banner />
      <default-banner />
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import DefaultBanner from './../components/DefaultBanner.vue'

export default Vue.extend({
  name: 'SideRightMenu',
  components: {DefaultBanner},
  props: {},
  data() {
    return {}
  },
  computed: {},
})
</script>

<style lang="postcss" scoped>
.container {
  padding-right: var(--spacing-4);
}

.list > * {
  margin: var(--spacing-4) 0;
}
</style>
