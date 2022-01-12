<template>
  <div class="card">
    <slot />
  </div>
</template>

<script lang="ts">
import Vue from 'vue'

export default Vue.extend({
  name: 'SubsidyCard',
  props: {},
  data() {
    return {}
  },
  computed: {},
})
</script>

<style lang="postcss" scoped>
.card {
  padding: var(--spacing-4);
  background-color: var(--white);
  border: solid 1px var(--border-grey-color);
  border-radius: var(--spacing-1);
  box-shadow: var(--shadow-elevation-1);
}
</style>
