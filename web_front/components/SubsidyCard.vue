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
  background-color: var(--white);
  border-radius: 8px;
}
</style>
