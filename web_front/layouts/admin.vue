<template>
  <el-container class="admin-layout">
    <el-header class="header-container">
      <admin-header />
    </el-header>
    <el-container>
      <el-aside class="left-side-menu" width="var(--left-side-width)">
        <admin-side-menu v-if="isAdmin" />
        <editor-side-menu v-if="isEditor" />
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
import {computed, defineComponent} from '@nuxtjs/composition-api'
import AdminHeader from '@/components/layouts/AdminHeader.vue'
import AdminSideMenu from '@/components/layouts/AdminSideMenu.vue'
import EditorSideMenu from '@/components/layouts/EditorSideMenu.vue'
import {accountModule} from '@/store'

export default defineComponent({
  name: 'AdminLayout',
  components: {
    AdminHeader,
    AdminSideMenu,
    EditorSideMenu,
  },
  setup(_props) {
    const isAdmin = computed(() => accountModule.isAdmin)
    const isEditor = computed(() => accountModule.isEditor)

    return {isAdmin, isEditor}
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
