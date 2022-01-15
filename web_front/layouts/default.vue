<template>
  <el-container class="default-layout">
    <el-aside class="side-menu-container" width="240px">
      <div class="title-container">補助金ドック</div>
      <global-side-menu />
    </el-aside>
    <el-container>
      <el-header class="header-container">
        <global-header />
      </el-header>
      <el-container class="center-container">
        <el-main>
          <nuxt />
        </el-main>
        <el-aside class="side-right-menu-container" width="316px">
          <side-right-menu />
        </el-aside>
      </el-container>
    </el-container>
  </el-container>
</template>

<script lang="ts">
import Vue from 'vue'
import {Container, Header, Aside, Main} from 'element-ui'
import GlobalHeader from './../components/GlobalHeader.vue'
import GlobalSideMenu from './../components/GlobalSideMenu.vue'
import SideRightMenu from './../components/SideRightMenu.vue'

export default Vue.extend({
  name: 'DefaultLayout',
  components: {
    [`${Container.name}`]: Container,
    [`${Header.name}`]: Header,
    [`${Aside.name}`]: Aside,
    [`${Main.name}`]: Main,
    GlobalHeader,
    GlobalSideMenu,
    SideRightMenu,
  },
  props: {},
  data() {
    return {}
  },
  computed: {},
})
</script>

<style lang="postcss" scoped>
.default-layout {
  height: 100vh;
}

.title-container {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  height: var(--spacing-15);
  padding-left: var(--spacing-4);
  font-size: 27px;
  font-family: 'Open Sans', sans-serif;
  color: #fff;
  background-color: #2a6f97;
  border-bottom: solid 1px var(--border-grey-color);
}

.side-menu-container {
  height: 100vh;
}

.header-container {
  padding: 0;
}

.center-container {
  height: 100vh;
  background-color: var(--main-background-color);
}

.side-right-menu-container {
  height: 100vh;
}
</style>
