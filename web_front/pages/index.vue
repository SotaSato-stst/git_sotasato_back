<template>
  <el-container class="center-container">
    <el-aside class="left-side-menu" width="var(--header-width)">
      <search-menu :loader="loader" />
    </el-aside>
    <el-main>
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
    </el-main>
    <el-aside width="316px">
      <side-right-menu />
    </el-aside>
  </el-container>
</template>

<script lang="ts">
import {computed, defineComponent} from '@nuxtjs/composition-api'
import {Container, Aside, Main, Pagination, Empty} from 'element-ui'
import SearchMenu from '~/components/SearchMenu.vue'
import SideRightMenu from '@/components/SideRightMenu.vue'
import CardLoading from '@/components/CardLoading.vue'
import SubsidyCard from '@/components/SubsidyCard.vue'
import {subsidiesModule} from '@/store'

export default defineComponent({
  name: 'IndexPage',
  components: {
    [`${Container.name}`]: Container,
    [`${Aside.name}`]: Aside,
    [`${Main.name}`]: Main,
    [`${Pagination.name}`]: Pagination,
    [`${Empty.name}`]: Empty,
    SearchMenu,
    SideRightMenu,
    SubsidyCard,
    CardLoading,
  },
  setup(_props) {
    const {loading} = subsidiesModule.loader
    const subsidies = computed(() => subsidiesModule.subsidies)
    const pagination = computed(() => subsidiesModule.pagination)

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

.left-side-menu {
  background-color: white;
  width: 100%;
  height: 100%;
}
</style>
