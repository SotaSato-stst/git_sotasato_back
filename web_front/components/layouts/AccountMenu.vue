<template>
  <el-menu class="menu" :default-active="selectedPage" @select="handleSelect">
    <el-menu-item index="account">
      <i class="el-icon-user"></i>
      <span>アカウント情報</span>
    </el-menu-item>
    <el-menu-item index="email">
      <i class="el-icon-message"></i>
      <span>メール設定</span>
    </el-menu-item>
  </el-menu>
</template>

<script lang="ts">
import {
  defineComponent,
  computed,
  useRouter,
  useRoute,
} from '@nuxtjs/composition-api'
import {routingService} from '@/services/routingService'

type menuType = 'account' | 'email'

export default defineComponent({
  name: 'AccountMenu',
  setup(_props) {
    const router = useRouter()
    const path = useRoute().value.path
    const selectedPage = computed(() => {
      if (path.startsWith(routingService.Account())) {
        return 'account'
      } else if (path.startsWith(routingService.EmailSetting())) {
        return 'email'
      } else {
        return 'account'
      }
    })
    const handleSelect = (value: menuType) => {
      switch (value) {
        case 'account':
          router.push(routingService.Account())
          break
        case 'email':
          router.push(routingService.EmailSetting())
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
  height: 100vh;
}
</style>
