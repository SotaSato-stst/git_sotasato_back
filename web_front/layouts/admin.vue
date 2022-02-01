<template>
  <el-container class="default-layout">
    <el-aside width="240px" class="side-menu-container">
      <div class="title-container">Admin</div>
      <admin-side-menu />
    </el-aside>
    <el-container>
      <el-header class="header-container">
        <admin-header />
      </el-header>
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
import AdminHeader from '@/components/AdminHeader.vue'
import AdminSideMenu from '@/components/AdminSideMenu.vue'

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
  color: var(--primary-color);
  border-bottom: solid 1px var(--border-grey-color);
}

.header-container {
  padding: 0;
}

.center-container {
  background-color: var(--main-background-color);
}
</style>
