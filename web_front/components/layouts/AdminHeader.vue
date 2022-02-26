<template>
  <div class="header-container">
    <div class="title-container">Admin</div>
    <div class="menu-container">
      <el-menu
        default-active="admin"
        class="header-menu"
        mode="horizontal"
        active-text-color="var(--primary-color)"
        @select="handleSelect"
      >
        <el-menu-item index="admin">
          <i class="el-icon-setting"></i>管理画面トップ
        </el-menu-item>
        <el-menu-item index="user">
          <i class="el-icon-s-order"></i>ユーザー画面トップ
        </el-menu-item>
      </el-menu>
      <global-dropdown-menu />
    </div>
  </div>
</template>

<script lang="ts">
import {defineComponent, useRouter} from '@nuxtjs/composition-api'
import GlobalDropdownMenu from '@/components/layouts/GlobalDropdownMenu.vue'

type menuType = 'admin' | 'user'

export default defineComponent({
  name: 'AdminHeader',
  components: {
    GlobalDropdownMenu,
  },
  setup(_props) {
    const router = useRouter()
    const handleSelect = (value: menuType) => {
      switch (value) {
        case 'admin':
          router.push('/admin')
          break
        case 'user':
          router.push('/')
          break
      }
    }

    return {handleSelect}
  },
})
</script>

<style lang="postcss" scoped>
.header-container {
  display: flex;
}

.title-container {
  display: flex;
  align-items: center;
  width: var(--header-width);
  padding-left: var(--spacing-4);
  box-sizing: border-box;
  font-size: 27px;
  font-family: 'Open Sans', sans-serif;
  color: var(--primary-color);
}

.menu-container {
  display: flex;
  justify-content: space-between;
  width: calc(100% - var(--header-width));
}

.header-menu {
  border-bottom: solid 1px var(--border-grey-color);
  box-sizing: border-box;
  height: 60px;
}

.header-menu > li {
  font-size: 14px;
  font-weight: bold;
  width: fit-content;
  color: var(--text-color);
}

.header-menu > li > i {
  font-size: 16px;
  width: fit-content;
}
</style>
