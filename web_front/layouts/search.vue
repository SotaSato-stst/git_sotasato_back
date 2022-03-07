<template>
  <el-container class="default-layout">
    <el-header class="header-container">
      <global-header />
    </el-header>
    <el-container class="center-container">
      <el-aside class="left-side-menu" width="var(--header-width)">
        <search-menu />
      </el-aside>
      <el-main class="main-container">
        <nuxt />
      </el-main>
      <el-aside width="316px">
        <side-right-menu />
      </el-aside>
    </el-container>
  </el-container>
</template>

<script lang="ts">
import {defineComponent} from '@nuxtjs/composition-api'
import GlobalHeader from '@/components/layouts/GlobalHeader.vue'
import SearchMenu from '@/components/subsidies/SearchMenu.vue'
import SideRightMenu from '@/components/layouts/SideRightMenu.vue'

export default defineComponent({
  name: 'DefaultLayout',
  components: {
    GlobalHeader,
    SearchMenu,
    SideRightMenu,
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

.left-side-menu {
  background-color: white;
  height: 100%;
}

.center-container {
  background-color: var(--main-background-color);
}

.main-container {
  padding: 0;
}
</style>
