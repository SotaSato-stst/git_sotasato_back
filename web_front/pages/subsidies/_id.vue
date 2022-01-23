// TODO:ikegaki 詳細ページをつくる
<template>
  <div class="container">
    <div v-if="subsidy">
      {{ subsidy.title }}
      {{ subsidy.url }}
    </div>
  </div>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  onMounted,
  useRoute,
} from '@nuxtjs/composition-api'
import {subsidiesModule} from '~/store'

export default defineComponent({
  name: 'SubsidyDetailPage',
  setup(_props) {
    const route = useRoute()
    const pageId = Number(route.value.params.id)
    const subsidy = computed(() => subsidiesModule.subsidy)

    onMounted(() => {
      subsidiesModule.getSubsidy(pageId)
    })

    return {
      subsidy,
    }
  },
})
</script>

<style lang="postcss" scoped>
.container > * {
  margin-bottom: var(--spacing-4);
}
</style>
