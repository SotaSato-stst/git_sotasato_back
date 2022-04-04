<template>
  <el-container class="layout">
    <el-header class="header-container">
      <global-header />
    </el-header>
    <el-container class="center-container">
      <el-aside class="left-side-menu" width="var(--left-side-width)">
        <account-menu />
      </el-aside>
      <el-main class="main-container">
        <nuxt />
      </el-main>
      <el-aside width="var(--right-side-width)">
        <side-right-menu />
      </el-aside>
    </el-container>
  </el-container>
</template>

<script lang="ts">
import {defineComponent} from '@nuxtjs/composition-api'
import GlobalHeader from '@/components/layouts/GlobalHeader.vue'
import AccountMenu from '@/components/layouts/AccountMenu.vue'
import SideRightMenu from '@/components/layouts/SideRightMenu.vue'

export default defineComponent({
  name: 'AccountLayout',
  components: {
    GlobalHeader,
    AccountMenu,
    SideRightMenu,
  },
})
</script>

<style lang="postcss" scoped>
.layout {
  height: 100vh;
}

.header-container {
  padding: 0;
}

.center-container {
  background-color: var(--main-background-color);
}

.left-side-menu {
  height: 100vh;
}

.main-container {
  padding: 0;
}
</style>
