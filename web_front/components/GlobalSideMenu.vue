<template>
  <div class="container"></div>
</template>

<script lang="ts">
import {defineComponent} from '@nuxtjs/composition-api'

export default defineComponent({
  name: 'GlobalSideMenu',
})
</script>

<style lang="postcss" scoped>
.container {
  padding: var(--spacing-4);
}
</style>
