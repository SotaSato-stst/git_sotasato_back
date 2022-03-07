<template>
  <el-menu
    :default-active="selectedPage"
    :class="$device.isMobile ? 'mobile-header-menu header-menu' : 'header-menu'"
    mode="horizontal"
    active-text-color="var(--primary-color)"
    @select="handleSelect"
  >
    <el-menu-item index="new">
      <i class="el-icon-s-order new"></i>新着
    </el-menu-item>
    <el-menu-item index="ranking">
      <i class="el-icon-s-flag flag"></i>ランキング
    </el-menu-item>
    <el-menu-item index="favorite">
      <i class="el-icon-star-on star"></i>保存済み
    </el-menu-item>
  </el-menu>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  useRoute,
  useRouter,
} from '@nuxtjs/composition-api'
import {routingService} from '@/services/routingService'

type menuType = 'new' | 'ranking' | 'favorite'

export default defineComponent({
  name: 'GlobalHeader',
  setup(_props) {
    const route = useRoute()
    const router = useRouter()
    const selectedPage = computed(() => {
      switch (route.value.path) {
        case routingService.Top():
          return 'new'
        case routingService.Ranking():
          return 'ranking'
        case routingService.Favorite():
          return 'favorite'
      }
    })
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
.header-menu {
  border-bottom: solid 1px var(--border-grey-color);
  box-sizing: border-box;
  height: 60px;
}

.mobile-header-menu {
  display: flex;
  justify-content: space-evenly;
  height: 40px;
}

.header-menu > li {
  font-size: 14px;
  font-weight: bold;
  width: fit-content;
  color: var(--text-color);
}

.mobile-header-menu > li {
  line-height: 40px;
  height: 40px;
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
