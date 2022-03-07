<template>
  <div class="container">リダイレクト中...</div>
</template>

<script lang="ts">
import {
  defineComponent,
  onMounted,
  useRouter,
  useRoute,
} from '@nuxtjs/composition-api'
import {routingService} from '@/services/routingService'

export default defineComponent({
  name: 'RedirectPage',
  layout: 'plain',
  setup(_props) {
    const router = useRouter()
    const route = useRoute()

    onMounted(() => {
      const id = route.value.query.id
      const resource = route.value.query.resource
      if (!id || !resource) {
        router.replace(routingService.NotFound())
      }
      switch (resource) {
        case 'subsidies':
          router.replace(routingService.SubsidyDetail(id))
          break
        case 'admin_subsidies':
          router.replace(routingService.AdminSubsidyDetail(id))
          break
        case 'admin_subsidy_drafts':
          router.replace(routingService.AdminSubsidyDraftDetail(id))
          break
        case 'admin_users':
          router.replace(routingService.AdminUserDetail(id))
          break
        case 'admin_companies':
          router.replace(routingService.AdminCompanyDetail(id))
          break
        default:
          router.replace(routingService.NotFound())
          break
      }
    })

    return {}
  },
  head(): object {
    return {
      title: 'トップ',
    }
  },
})
</script>

<style lang="postcss" scoped>
.container > * {
  margin: auto;
}
</style>
