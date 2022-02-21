<template>
  <el-menu class="menu" :default-active="selectedPage" @select="handleSelect">
    <el-menu-item index="new_urls">
      <i class="el-icon-news"></i>
      <span>未対応の新着 ({{ totalCount }}件)</span>
    </el-menu-item>
    <el-menu-item index="subsidies">
      <i class="el-icon-s-order"></i>
      <span>補助金情報管理</span>
    </el-menu-item>
    <el-menu-item index="companies">
      <i class="el-icon-office-building"></i>
      <span>会社管理</span>
    </el-menu-item>
    <el-menu-item index="users">
      <i class="el-icon-user"></i>
      <span>ユーザー管理</span>
    </el-menu-item>
    <el-menu-item index="searched_keywords">
      <i class="el-icon-search"></i>
      <span>検索ワード分析</span>
    </el-menu-item>
  </el-menu>
</template>

<script lang="ts">
import {Menu, MenuItem} from 'element-ui'
import {
  defineComponent,
  computed,
  onMounted,
  useRouter,
  useRoute,
} from '@nuxtjs/composition-api'
import {routingService} from '@/services/routingService'
import {subsidyDraftsModule} from '@/store'

type menuType =
  | 'new_urls'
  | 'subsidies'
  | 'companies'
  | 'users'
  | 'searched_keywords'

export default defineComponent({
  name: 'AdminSideMenu',
  components: {
    [`${Menu.name}`]: Menu,
    [`${MenuItem.name}`]: MenuItem,
  },
  setup(_props) {
    const router = useRouter()
    const path = useRoute().value.path
    const totalCount = computed(() => subsidyDraftsModule.pagination.itemsTotal)
    const selectedPage = computed(() => {
      if (path.startsWith(routingService.AdminSubsidies())) {
        return 'subsidies'
      } else if (path.startsWith(routingService.AdminCompanies())) {
        return 'companies'
      } else if (path.startsWith(routingService.AdminUsers())) {
        return 'users'
      } else if (path.startsWith(routingService.AdminSearchedKeywords())) {
        return 'searched_keywords'
      } else {
        return 'new_urls'
      }
    })
    const handleSelect = (value: menuType) => {
      switch (value) {
        case 'new_urls':
          router.push(routingService.AdminTop())
          break
        case 'subsidies':
          router.push(routingService.AdminSubsidies())
          break
        case 'companies':
          router.push(routingService.AdminCompanies())
          break
        case 'users':
          router.push(routingService.AdminUsers())
          break
        case 'searched_keywords':
          router.push(routingService.AdminSearchedKeywords())
          break
      }
    }

    onMounted(() => {
      subsidyDraftsModule.getSubsidyDrafts()
    })

    return {totalCount, selectedPage, handleSelect}
  },
})
</script>

<style lang="postcss" scoped>
.menu {
  border: none;
}
</style>
