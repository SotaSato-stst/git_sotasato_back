<template>
  <el-dropdown class="dropdown-container" @command="handleSelect">
    <span class="dropdown-link">
      <el-button icon="el-icon-setting">
        設定<i class="el-icon-arrow-down el-icon--right"></i>
      </el-button>
    </span>
    <el-dropdown-menu slot="dropdown">
      <el-dropdown-item command="user_setting">アカウント情報</el-dropdown-item>
      <el-dropdown-item command="top" divided>ユーザー画面</el-dropdown-item>
      <el-dropdown-item command="admin">管理画面</el-dropdown-item>
      <el-dropdown-item command="sign_out" divided>
        ログアウト
      </el-dropdown-item>
    </el-dropdown-menu>
  </el-dropdown>
</template>

<script lang="ts">
import {Dropdown, DropdownItem, Button} from 'element-ui'
import {defineComponent, useRouter} from '@nuxtjs/composition-api'
import {getAuth, signOut} from 'firebase/auth'
import {routingService} from '@/services/routingService'

type menuType = 'user_setting' | 'admin' | 'sign_out' | 'top'

export default defineComponent({
  name: 'GlobalDropdownMenu',
  components: {
    [`${Dropdown.name}`]: Dropdown,
    [`${DropdownItem.name}`]: DropdownItem,
    [`${Button.name}`]: Button,
  },
  setup(_props) {
    const router = useRouter()
    const handleSelect = (value: menuType) => {
      switch (value) {
        case 'user_setting':
          router.push(routingService.Top())
          break
        case 'admin':
          router.push(routingService.AdminTop())
          break
        case 'top':
          router.push(routingService.Top())
          break
        case 'sign_out':
          signOut(getAuth())
          break
      }
    }

    return {handleSelect}
  },
})
</script>

<style lang="postcss" scoped>
.dropdown-container {
  margin: auto var(--spacing-3);
}

.dropdown-link {
  cursor: pointer;
  font-size: 24px;
}
</style>
