<template>
  <el-menu class="menu" default-active="new_urls" @select="handleSelect">
    <el-menu-item index="new_urls">
      <i class="el-icon-news"></i>
      <span>未対応の新着</span>
    </el-menu-item>
    <el-menu-item index="all_subsidies">
      <i class="el-icon-s-order"></i>
      <span>補助金情報管理</span>
    </el-menu-item>
    <el-menu-item index="company">
      <i class="el-icon-office-building"></i>
      <span>会社管理</span>
    </el-menu-item>
    <el-menu-item index="user">
      <i class="el-icon-user"></i>
      <span>ユーザー管理</span>
    </el-menu-item>
  </el-menu>
</template>

<script lang="ts">
import {Menu, MenuItem} from 'element-ui'
import {defineComponent, useRouter} from '@nuxtjs/composition-api'
import {routingService} from '@/services/routingService'

type menuType = 'new_urls' | 'all_subsidies' | 'company' | 'user'

export default defineComponent({
  name: 'AdminSideMenu',
  components: {
    [`${Menu.name}`]: Menu,
    [`${MenuItem.name}`]: MenuItem,
  },
  setup(_props) {
    const router = useRouter()
    const selectedPage: menuType = 'all_subsidies'
    const handleSelect = (value: menuType) => {
      switch (value) {
        case 'new_urls':
          router.push(routingService.AdminTop())
          break
        case 'all_subsidies':
          router.push(routingService.AdminSubsidies())
          break
        case 'company':
          router.push(routingService.AdminCompanies())
          break
        case 'user':
          router.push(routingService.AdminUsers())
          break
      }
    }

    return {selectedPage, handleSelect}
  },
})
</script>

<style lang="postcss" scoped>
.menu {
  border: none;
}
</style>
