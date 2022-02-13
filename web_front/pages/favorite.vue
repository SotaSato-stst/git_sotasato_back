<template>
  <el-container class="center-container">
    <el-aside class="left-side-menu" width="var(--header-width)">
      <search-menu />
    </el-aside>
    <el-main>
      <div class="container">
        <div class="title">保存済みの補助金情報</div>
        <card-loading :loading="loading" />
        <div v-for="subsidy in userFavoriteSubsidies" :key="subsidy.id">
          <subsidy-card v-if="!loading" :subsidy="subsidy" />
        </div>
        <el-empty
          v-if="!loading && userFavoriteSubsidies.length == 0"
          description="データがありません"
        />
        <el-pagination
          v-if="userFavoriteSubsidies.length > 0 && !loading"
          background
          layout="prev, pager, next"
          :page-count="pagination.totalPages"
          :total="pagination.itemsTotal"
          :page-size="pagination.itemsPerPage"
          :current-page="pagination.currentPage"
          @current-change="getPage"
        />
      </div>
    </el-main>
    <el-aside width="316px">
      <side-right-menu />
    </el-aside>
  </el-container>
</template>

<script lang="ts">
import {computed, defineComponent, onMounted} from '@nuxtjs/composition-api'
import {Container, Aside, Main, Pagination, Empty} from 'element-ui'
import SearchMenu from '@/components/subsidies/SearchMenu.vue'
import SideRightMenu from '@/components/layouts/SideRightMenu.vue'
import CardLoading from '@/components/CardLoading.vue'
import SubsidyCard from '@/components/subsidies/SubsidyCard.vue'
import {favoriteSubsidiesModule} from '@/store'

export default defineComponent({
  name: 'FavoritePage',
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
    const {loading, load} = favoriteSubsidiesModule.loader
    const userFavoriteSubsidies = computed(
      () => favoriteSubsidiesModule.userFavoriteSubsidies,
    )
    const pagination = computed(() => favoriteSubsidiesModule.pagination)
    const getPage = (page: number) => {
      favoriteSubsidiesModule.setUserFavoriteSubsidies([])
      favoriteSubsidiesModule.getUserFavoriteSubsidies(page)
    }

    onMounted(() => {
      load(loading, () => {
        favoriteSubsidiesModule.getUserFavoriteSubsidies()
      })
    })

    return {
      loading,
      userFavoriteSubsidies,
      pagination,
      getPage,
    }
  },
  head(): object {
    return {
      title: '保存済みの補助金情報',
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

.title {
  font-size: 21px;
  font-weight: bold;
}
</style>
