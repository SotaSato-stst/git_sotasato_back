<template>
  <div class="container">
    <subsidy-card />
    <subsidy-card />
    <subsidy-card />
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import SubsidyCard from './../components/SubsidyCard.vue'

export default Vue.extend({
  name: 'IndexPage',
  components: {SubsidyCard},
})
</script>

<style lang="postcss" scoped>
.container > * {
  margin-bottom: var(--spacing-4);
}
</style>
