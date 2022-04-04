<template>
  <div>
    <!-- デスクトップレイアウト -->
    <div v-if="!$device.isMobile" class="header-container">
      <div class="title" @click="goToTop()">補助金ドック</div>
      <div class="menu-container">
        <global-nav-menu />
        <global-dropdown-menu />
      </div>
    </div>
    <!-- モバイルレイアウト -->
    <div v-if="$device.isMobile">
      <div class="mobile-header-container">
        <div class="mobile-icon-container">
          <el-button
            icon="el-icon-search"
            type="text"
            class="mobile-search-button"
            @click="drawer = true"
          />
          <el-drawer
            title="検索フォーム"
            :visible.sync="drawer"
            size="100%"
            direction="ltr"
          >
            <search-menu :on-search="onSearch" />
          </el-drawer>
          <!-- drawerは開くまで子要素をmoutしないため、リクエストが飛ばないので -->
          <search-menu style="display: none" />
        </div>
        <div class="mobile-title" @click="goToTop()">補助金ドック</div>
        <div class="mobile-icon-container">
          <global-dropdown-menu />
        </div>
      </div>
      <global-nav-menu />
    </div>
  </div>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  useRoute,
  useRouter,
  ref,
} from '@nuxtjs/composition-api'
import GlobalDropdownMenu from '@/components/layouts/GlobalDropdownMenu.vue'
import GlobalNavMenu from '@/components/layouts/GlobalNavMenu.vue'
import SearchMenu from '@/components/subsidies/SearchMenu.vue'
import {routingService} from '@/services/routingService'

type menuType = 'new' | 'ranking' | 'favorite'

export default defineComponent({
  name: 'GlobalHeader',
  components: {
    GlobalDropdownMenu,
    GlobalNavMenu,
    SearchMenu,
  },
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
    const goToTop = () => router.push('/')
    const drawer = ref(false)
    const onSearch = () => {
      drawer.value = false
    }

    return {selectedPage, handleSelect, goToTop, drawer, onSearch}
  },
})
</script>

<style lang="postcss" scoped>
.header-container {
  display: flex;
  height: 60px;
  box-sizing: border-box;
  border-bottom: solid 1px var(--border-grey-color);
}

.mobile-header-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.title {
  display: flex;
  align-items: center;
  width: var(--left-side-width);
  padding-left: var(--spacing-4);
  box-sizing: border-box;
  font-size: 27px;
  color: var(--primary-color);
  cursor: pointer;
}

.mobile-title {
  font-family: 'Open Sans', sans-serif;
  color: var(--primary-color);
  font-size: 24px;
}

.menu-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: calc(100% - var(--left-side-width));
}

.menu-container > div {
  margin: auto var(--spacing-3);
}

.mobile-icon-container {
  margin: auto var(--spacing-3);
}

.mobile-search-button {
  font-size: 18px;
  color: var(--text-font-color);
}
</style>
