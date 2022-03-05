<template>
  <el-container class="center-container">
    <el-aside class="left-side-menu" width="var(--header-width)">
      <viewed-subsidies />
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
        <pagination
          v-if="userFavoriteSubsidies.length > 0 && !loading"
          :pagination="pagination"
          :request-page="getPage"
        />
      </div>
    </el-main>
  </el-container>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  onMounted,
  useRoute,
} from '@nuxtjs/composition-api'
import ViewedSubsidies from '@/components/subsidies/ViewedSubsidies.vue'
import CardLoading from '@/components/CardLoading.vue'
import Pagination from '@/components/Pagination.vue'
import SubsidyCard from '@/components/subsidies/SubsidyCard.vue'
import {favoriteSubsidiesModule} from '@/store'

export default defineComponent({
  name: 'FavoritePage',
  components: {
    ViewedSubsidies,
    SubsidyCard,
    Pagination,
    CardLoading,
  },
  setup(_props) {
    const route = useRoute()
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
        const pageQuery = route.value.query.page?.toString() || null
        const page = pageQuery ? Number(pageQuery) : 1
        favoriteSubsidiesModule.getUserFavoriteSubsidies(page)
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
