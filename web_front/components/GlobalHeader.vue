<template>
  <div class="container">Header</div>
</template>

<script lang="ts">
import Vue from 'vue'

export default Vue.extend({
  name: 'GlobalHeader',
  props: {},
  data() {
    return {}
  },
  computed: {},
})
</script>

<style lang="postcss" scoped>
.container {
  height: var(--spacing-12);
  padding: var(--spacing-2) var(--spacing-1);
}
</style>
