<template>
  <div>
    <div class="mobile-header-container">
      <div class="mobile-icon-container">
        <el-button
          icon="el-icon-menu"
          type="text"
          class="mobile-menu-button"
          @click="drawer = true"
        />
        <el-drawer
          title="メニュー"
          :visible.sync="drawer"
          size="100%"
          direction="ltr"
        >
          <admin-side-menu v-if="isAdmin" />
          <editor-side-menu v-if="isEditor" />
        </el-drawer>
      </div>
      <div class="mobile-title">Admin</div>
      <div class="mobile-icon-container">
        <global-dropdown-menu />
      </div>
    </div>
    <div class="content-body">
      <nuxt />
    </div>
  </div>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  ref,
  watch,
  useRoute,
} from '@nuxtjs/composition-api'
import AdminSideMenu from '@/components/layouts/AdminSideMenu.vue'
import EditorSideMenu from '@/components/layouts/EditorSideMenu.vue'
import GlobalDropdownMenu from '@/components/layouts/GlobalDropdownMenu.vue'
import {accountModule} from '@/store'

export default defineComponent({
  name: 'AdminMobileLayout',
  components: {
    GlobalDropdownMenu,
    AdminSideMenu,
    EditorSideMenu,
  },
  setup(_props) {
    const isAdmin = computed(() => accountModule.isAdmin)
    const isEditor = computed(() => accountModule.isEditor)
    const drawer = ref(false)
    const route = useRoute()

    watch(route, (_route, _old) => {
      drawer.value = false
    })

    return {isAdmin, isEditor, drawer}
  },
})
</script>

<style lang="postcss" scoped>
.mobile-header-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: solid 1px var(--border-grey-color);
}

.mobile-title {
  font-family: 'Open Sans', sans-serif;
  color: var(--primary-color);
  font-size: 24px;
}

.mobile-icon-container {
  margin: auto var(--spacing-3);
}

.mobile-menu-button {
  font-size: 18px;
  color: var(--text-font-color);
}

.content-body {
  padding: var(--spacing-4);
}
</style>
