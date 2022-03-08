<template>
  <div class="container">
    <div class="title">新着の情報一覧 ({{ pagination.itemsTotal }}件)</div>
    <card-loading :loading="loading" />
    <div v-for="subsidy in subsidies" :key="subsidy.id">
      <subsidy-card v-if="!loading" :subsidy="subsidy" />
    </div>
    <el-empty
      v-if="!loading && subsidies.length == 0"
      description="条件に当てはまるデータがありません"
    />
    <pagination
      v-if="subsidies.length > 0 && !loading"
      :pagination="pagination"
      :request-page="getPage"
    />
  </div>
</template>

<script lang="ts">
import {computed, defineComponent} from '@nuxtjs/composition-api'
import CardLoading from '@/components/CardLoading.vue'
import Pagination from '@/components/Pagination.vue'
import SubsidyCard from '@/components/subsidies/SubsidyCard.vue'
import {subsidiesModule} from '@/store'

export default defineComponent({
  name: 'IndexPage',
  components: {
    SubsidyCard,
    Pagination,
    CardLoading,
  },
  layout: ctx => (ctx.$device.isMobile ? 'mobile' : 'search'),
  setup(_props) {
    const {loading} = subsidiesModule.loader
    const subsidies = computed(() => subsidiesModule.subsidies)
    const pagination = computed(() => subsidiesModule.pagination)

    const getPage = (page: number) => {
      subsidiesModule.setSubsidies([])
      subsidiesModule.getSubsidies(page)
    }

    return {
      loading,
      subsidies,
      pagination,
      getPage,
    }
  },
  head(): object {
    return {
      title: '新着一覧',
    }
  },
})
</script>

<style lang="postcss" scoped>
.container {
  padding: var(--spacing-5);
}

.container > * {
  margin-bottom: var(--spacing-4);
}

.title {
  font-size: 22px;
  font-weight: bold;
}
</style>
