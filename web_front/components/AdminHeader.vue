<template>
  <div class="header-container">
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
</template>

<script lang="ts">
import {Menu, MenuItem} from 'element-ui'
import {defineComponent, useRouter} from '@nuxtjs/composition-api'
import GlobalDropdownMenu from '@/components/GlobalDropdownMenu.vue'

type menuType = 'admin' | 'user'

export default defineComponent({
  name: 'AdminHeader',
  components: {
    [`${Menu.name}`]: Menu,
    [`${MenuItem.name}`]: MenuItem,
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
  justify-content: space-between;
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
