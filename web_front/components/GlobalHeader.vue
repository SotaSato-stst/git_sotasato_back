<template>
  <div class="header-container">
    <el-menu
      :default-active="selectedPage"
      class="header-menu"
      mode="horizontal"
      active-text-color="var(--primary-color)"
      @select="handleSelect"
    >
      <el-menu-item index="new">
        <i class="el-icon-s-order new"></i>新着 (12件)
      </el-menu-item>
      <el-menu-item index="ranking">
        <i class="el-icon-s-flag flag"></i>ランキング
      </el-menu-item>
      <el-menu-item index="favorite">
        <i class="el-icon-star-on star"></i>保存済み
      </el-menu-item>
    </el-menu>
    <el-dropdown class="dropdown-container" @command="handleSelect">
      <span class="dropdown-link">
        <el-button icon="el-icon-setting">
          設定<i class="el-icon-arrow-down el-icon--right"></i>
        </el-button>
      </span>
      <el-dropdown-menu slot="dropdown">
        <el-dropdown-item command="user_setting">ユーザー情報</el-dropdown-item>
        <el-dropdown-item command="sign_out" divided>
          ログアウト
        </el-dropdown-item>
      </el-dropdown-menu>
    </el-dropdown>
  </div>
</template>

<script lang="ts">
import {Menu, MenuItem, Dropdown, DropdownItem, Button} from 'element-ui'
import {getAuth, signOut} from 'firebase/auth'
import {defineComponent, useRouter} from '@nuxtjs/composition-api'

type menuType = 'new' | 'ranking' | 'favorite' | 'user_setting' | 'sign_out'

export default defineComponent({
  name: 'GlobalHeader',
  components: {
    [`${Menu.name}`]: Menu,
    [`${MenuItem.name}`]: MenuItem,
    [`${Dropdown.name}`]: Dropdown,
    [`${DropdownItem.name}`]: DropdownItem,
    [`${Button.name}`]: Button,
  },
  setup(_props) {
    const router = useRouter()
    const selectedPage: menuType = 'new'
    const handleSelect = (value: menuType) => {
      switch (value) {
        case 'new':
          router.push('/')
          break
        case 'ranking':
          router.push('/')
          break
        case 'favorite':
          router.push('/')
          break
        case 'user_setting':
          router.push('/')
          break
        case 'sign_out':
          signOut(getAuth())
          break
      }
    }

    return {selectedPage, handleSelect}
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

.star,
.header-menu > li.is-active > i.star {
  color: var(--hilight-yellow);
}

.flag,
.header-menu > li.is-active > i.flag {
  color: #f48c06;
}

.new,
.header-menu > li.is-active > i.new {
  color: #48cae4;
}

.dropdown-container {
  margin: auto var(--spacing-3);
}

.dropdown-link {
  cursor: pointer;
  font-size: 24px;
}
</style>
