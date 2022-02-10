<template>
  <el-card class="card" shadow="never" :body-style="{padding: '0px'}">
    <a :href="href" target="_blank"><img :src="src" class="image" /></a>
  </el-card>
</template>

<script lang="ts">
import {defineComponent, PropType} from '@nuxtjs/composition-api'
import {Card} from 'element-ui'

export default defineComponent({
  name: 'SmallBanner',
  components: {
    [`${Card.name}`]: Card,
  },
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
    return {}
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
