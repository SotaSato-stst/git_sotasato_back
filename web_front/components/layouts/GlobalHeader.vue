<template>
  <div class="header-container">
    <div class="title-container">補助金ドック</div>
    <div class="menu-container">
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
      <global-dropdown-menu />
    </div>
  </div>
</template>

<script lang="ts">
import {Menu, MenuItem} from 'element-ui'
import {defineComponent, useRouter} from '@nuxtjs/composition-api'
import GlobalDropdownMenu from '@/components/layouts/GlobalDropdownMenu.vue'
import {routingService} from '@/services/routingService'

type menuType = 'new' | 'ranking' | 'favorite'

export default defineComponent({
  name: 'GlobalHeader',
  components: {
    [`${Menu.name}`]: Menu,
    [`${MenuItem.name}`]: MenuItem,
    GlobalDropdownMenu,
  },
  setup(_props) {
    const router = useRouter()
    const selectedPage: menuType = 'new'
    const handleSelect = (value: menuType) => {
      switch (value) {
        case 'new':
          router.push(routingService.Top())
          break
        case 'ranking':
          router.push(routingService.Ranking())
          break
        case 'favorite':
          router.push(routingService.Favorite())
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
  border: none;
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
</style>
