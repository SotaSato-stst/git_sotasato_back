<template>
  <el-container class="default-layout">
    <el-header class="header-container">
      <global-header />
    </el-header>
    <el-container>
      <el-aside class="side-menu-container" width="240px">
        <global-side-menu />
      </el-aside>
      <el-main>
        <nuxt />
      </el-main>
    </el-container>
  </el-container>
</template>

<script lang="ts">
import Vue from 'vue'
import {Container, Header, Aside, Main} from 'element-ui'
import GlobalHeader from './../components/GlobalHeader.vue'
import GlobalSideMenu from './../components/GlobalSideMenu.vue'

export default Vue.extend({
  name: 'DefaultLayout',
  components: {
    [`${Container.name}`]: Container,
    [`${Header.name}`]: Header,
    [`${Aside.name}`]: Aside,
    [`${Main.name}`]: Main,
    GlobalHeader,
    GlobalSideMenu,
  },
  props: {},
  data() {
    return {}
  },
  computed: {},
})
</script>

<style>
body {
  margin: 0;
}
</style>

<style lang="postcss" scoped>
.default-layout {
  height: 100vh;
}

.header-container {
  background-color: white;
  border-bottom: solid 1px var(--border-grey-color);
}

.side-menu-container {
  height: 100vh;
  border-right: solid 1px var(--border-grey-color);
}
</style>
