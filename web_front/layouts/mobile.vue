<template>
  <div>
    <global-header />
    <nuxt />
  </div>
</template>

<script lang="ts">
import {defineComponent} from '@nuxtjs/composition-api'
import GlobalHeader from '@/components/layouts/GlobalHeader.vue'

export default defineComponent({
  name: 'MobileLayout',
  components: {
    GlobalHeader,
  },
})
</script>
