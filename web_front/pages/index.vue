<template>
  <div class="container">
    <card-loading :loading="loading" />
    <div v-for="subsidy in subsidies" :key="subsidy.id">
      <subsidy-card :subsidy="subsidy" />
    </div>
    <el-empty
      v-if="!loading && subsidies.length == 0"
      description="データがありません"
    />
    <el-pagination
      v-if="subsidies.length > 0"
      background
      layout="prev, pager, next"
      :page-count="pagination.totalPages"
      :total="pagination.itemsTotal"
      :page-size="pagination.itemsPerPage"
      :current-page="pagination.currentPage"
    />
  </div>
</template>

<script lang="ts">
import {computed, defineComponent, onMounted} from '@nuxtjs/composition-api'
import {Pagination, Empty} from 'element-ui'
import SubsidyCard from '@/components/SubsidyCard.vue'
import CardLoading from '~/components/CardLoading.vue'
import {subsidiesModule} from '@/store'
import {useLoader} from '@/services/useLoader'

export default defineComponent({
  name: 'IndexPage',
  components: {
    [`${Pagination.name}`]: Pagination,
    [`${Empty.name}`]: Empty,
    SubsidyCard,
    CardLoading,
  },
  setup(_props) {
    const {loading, load} = useLoader()
    const subsidies = computed(() => subsidiesModule.subsidies)
    const pagination = computed(() => subsidiesModule.pagination)

    onMounted(() => {
      load(loading, () => {
        subsidiesModule.getSubsidies()
      })
    })

    return {
      loading,
      subsidies,
      pagination,
    }
  },
})
</script>

<style lang="postcss" scoped>
.container > * {
  margin-bottom: var(--spacing-4);
}
</style>
