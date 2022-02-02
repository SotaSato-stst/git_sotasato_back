<template>
  <div class="container">
    <card-loading :loading="loading" />
    <div v-for="subsidy in subsidies" :key="subsidy.id">
      <subsidy-card :subsidy="subsidy" />
    </div>
    <el-pagination
      background
      layout="prev, pager, next"
      :page-count="totalPages"
      :total="itemsTotal"
      :page-size="itemsPerPage"
      :current-page="currentPage"
    />
  </div>
</template>

<script lang="ts">
import {computed, defineComponent, onMounted} from '@nuxtjs/composition-api'
import {Pagination} from 'element-ui'
import SubsidyCard from '@/components/SubsidyCard.vue'
import CardLoading from '~/components/CardLoading.vue'
import {subsidiesModule} from '@/store'
import {useLoader} from '@/services/useLoader'

export default defineComponent({
  name: 'IndexPage',
  components: {
    [`${Pagination.name}`]: Pagination,
    SubsidyCard,
    CardLoading,
  },
  setup(_props) {
    const {loading, load} = useLoader()
    const subsidies = computed(() => subsidiesModule.subsidies)
    const currentPage = computed(() => subsidiesModule.currentPage)
    const totalPages = computed(() => subsidiesModule.totalPages)
    const itemsTotal = computed(() => subsidiesModule.itemsTotal)
    const itemsPerPage = computed(() => subsidiesModule.itemsPerPage)

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
      itemsTotal,
      itemsPerPage,
    }
  },
})
</script>

<style lang="postcss" scoped>
.container > * {
  margin-bottom: var(--spacing-4);
}
</style>
