<template>
  <el-card
    class="card"
    shadow="never"
    :body-style="{padding: '0px'}"
    @click="click"
  >
    <a :href="href" target="_blank"><img :src="src" class="image" /></a>
  </el-card>
</template>

<script lang="ts">
import {defineComponent, PropType} from '@nuxtjs/composition-api'
import {getAnalytics, logEvent} from 'firebase/analytics'

export default defineComponent({
  name: 'SmallBanner',
  props: {
    href: {
      type: String as PropType<string>,
      required: true,
    },
    src: {
      type: String as PropType<string>,
      required: true,
    },
  },
  setup(_props) {
    const analytics = getAnalytics()
    const click = () => {
      logEvent(analytics, 'click_banner')
    }

    return {click}
  },
})
</script>

<style lang="postcss" scoped>
.card {
  width: var(--banner-width);
  height: fit-content;
  cursor: pointer;
}

.image {
  width: 100%;
}
</style>
