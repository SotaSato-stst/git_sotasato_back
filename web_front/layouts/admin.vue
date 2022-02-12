<template>
  <el-container class="admin-layout">
    <el-header class="header-container">
      <admin-header />
    </el-header>
    <el-container>
      <el-aside class="left-side-menu" width="var(--header-width)">
        <admin-side-menu />
      </el-aside>
      <el-container class="center-container">
        <el-main>
          <nuxt />
        </el-main>
      </el-container>
    </el-container>
  </el-container>
</template>

<script lang="ts">
import {defineComponent} from '@nuxtjs/composition-api'
import {Container, Header, Aside, Main} from 'element-ui'
import AdminHeader from '@/components/layouts/AdminHeader.vue'
import AdminSideMenu from '@/components/layouts/AdminSideMenu.vue'

export default defineComponent({
  name: 'AdminLayout',
  components: {
    [`${Container.name}`]: Container,
    [`${Header.name}`]: Header,
    [`${Aside.name}`]: Aside,
    [`${Main.name}`]: Main,
    AdminHeader,
    AdminSideMenu,
  },
})
</script>

<style lang="postcss" scoped>
.admin-layout {
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
