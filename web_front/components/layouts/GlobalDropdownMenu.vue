<template>
  <el-dropdown @command="handleSelect">
    <div>
      <!-- デスクトップの場合は文字ボタン -->
      <span v-if="!$device.isMobile" class="dropdown-link">
        <el-button icon="el-icon-setting">
          設定<i class="el-icon-arrow-down el-icon--right"></i>
        </el-button>
      </span>
      <!-- モバイルの場合はアイコンボタン -->
      <el-button
        v-if="$device.isMobile"
        icon="el-icon-more"
        type="text"
        class="mobile-dropdown-button"
      />
    </div>
    <el-dropdown-menu slot="dropdown">
      <el-dropdown-item command="account">アカウント情報</el-dropdown-item>
      <el-dropdown-item v-if="isAdmin || isEditor" command="top" divided
        >ユーザー画面</el-dropdown-item
      >
      <el-dropdown-item v-if="isAdmin || isEditor" command="admin"
        >管理画面</el-dropdown-item
      >
      <el-dropdown-item command="sign_out" divided>
        ログアウト
      </el-dropdown-item>
    </el-dropdown-menu>
  </el-dropdown>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  onMounted,
  onUnmounted,
  useRouter,
} from '@nuxtjs/composition-api'
import {getAuth, signOut} from 'firebase/auth'
import {accountModule} from '@/store'
import {routingService} from '@/services/routingService'
import {notifyInfo} from '@/services/notify'

type menuType = 'account' | 'admin' | 'sign_out' | 'top'

export default defineComponent({
  name: 'GlobalDropdownMenu',
  setup(_props) {
    const isAdmin = computed(() => accountModule.isAdmin)
    const isEditor = computed(() => accountModule.isEditor)
    const router = useRouter()
    const handleSelect = (value: menuType) => {
      switch (value) {
        case 'account':
          router.push(routingService.Account())
          break
        case 'admin':
          router.push(routingService.AdminTop())
          break
        case 'top':
          router.push(routingService.Top())
          break
        case 'sign_out':
          signOut(getAuth())
          notifyInfo('ログアウトしました', 'ログインが必要です')
          router.push(routingService.SignIn())
          break
      }
    }

    onMounted(async () => {
      if (!accountModule.currentUser) {
        await accountModule.getCurrentUser()
      }
    })

    onUnmounted(() => {
      accountModule.setCurrentUser(null)
    })

    return {isAdmin, isEditor, handleSelect}
  },
})
</script>

<style lang="postcss" scoped>
.dropdown-link {
  cursor: pointer;
  font-size: 24px;
}

.mobile-dropdown-button {
  font-size: 18px;
  color: var(--text-font-color);
}
</style>
