<template>
  <el-container class="default-layout">
    <el-header class="header-container">
      <global-header />
    </el-header>
    <el-container class="center-container">
      <nuxt />
    </el-container>
  </el-container>
</template>

<script lang="ts">
import {defineComponent} from '@nuxtjs/composition-api'
import GlobalHeader from '@/components/layouts/GlobalHeader.vue'

export default defineComponent({
  name: 'DefaultLayout',
  components: {
    GlobalHeader,
  },
})
</script>

<style lang="postcss" scoped>
.default-layout {
  height: 100vh;
}

.header-container {
  padding: 0;
  border-bottom: solid 1px var(--border-grey-color);
}

.center-container {
  background-color: var(--main-background-color);
}
</style>
