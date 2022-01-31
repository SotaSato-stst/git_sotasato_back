<template>
  <div class="container">
    <card-loading :loading="loading" />
    <div v-for="subsidy in subsidies" :key="subsidy.id">
      <subsidy-card :subsidy="subsidy" />
    </div>
  </div>
</template>

<script lang="ts">
import {computed, defineComponent, onMounted} from '@nuxtjs/composition-api'
import SubsidyCard from '@/components/SubsidyCard.vue'
import CardLoading from '~/components/CardLoading.vue'
import {subsidiesModule} from '~/store'
import {useLoader} from '@/services/useLoader'

export default defineComponent({
  name: 'IndexPage',
  components: {SubsidyCard, CardLoading},
  setup(_props) {
    const {loading, load} = useLoader()
    const subsidies = computed(() => subsidiesModule.subsidies)
    const currentPage = computed(() => subsidiesModule.currentPage)
    const totalPages = computed(() => subsidiesModule.totalPages)

    onMounted(() => {
      load(loading, () => {
        subsidiesModule.getSubsidies()
      })
    })

    return {
      loading,
      subsidies,
      currentPage,
      totalPages,
    }
  },
})
</script>

<style lang="postcss" scoped>
.container > * {
  margin-bottom: var(--spacing-4);
}
</style>
