<template>
  <el-menu class="menu" :default-active="selectedPage" @select="handleSelect">
    <el-menu-item index="new_urls">
      <i class="el-icon-news"></i>
      <span>未対応の新着</span>
    </el-menu-item>
    <el-menu-item index="subsidies">
      <i class="el-icon-s-order"></i>
      <span>補助金情報</span>
    </el-menu-item>
    <el-menu-item index="benefits">
      <i class="el-icon-house"></i>
      <span>家庭向け給付金</span>
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

type menuType = 'new_urls' | 'subsidies' | 'benefits'

export default defineComponent({
  name: 'EditorSideMenu',
  setup(_props) {
    const router = useRouter()
    const path = useRoute().value.path
    const selectedPage = computed(() => {
      if (path.startsWith(routingService.AdminSubsidies())) {
        return 'subsidies'
      } else if (path.startsWith(routingService.AdminBenefits())) {
        return 'benefits'
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
        case 'benefits':
          router.push(routingService.AdminBenefits())
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

.el-icon-s-order,
.is-active > i.el-icon-s-order {
  color: #48cae4;
}

.el-icon-house,
.is-active > i.el-icon-house {
  color: #67c23a;
}

.el-icon-news,
.is-active > i.el-icon-news {
  color: red;
}
</style>
