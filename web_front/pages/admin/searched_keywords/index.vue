<template>
  <div class="container">
    <div class="title-header">
      <div class="title">検索ワード 一覧</div>
    </div>
    <card-loading :loading="loading" />
    <el-table v-if="!loading" :data="keywords" stripe style="width: 100%">
      <el-table-column prop="content" label="検索ワード" />
      <el-table-column prop="count" label="検索回数" />
    </el-table>
  </div>
</template>

<script lang="ts">
import {computed, defineComponent, onMounted} from '@nuxtjs/composition-api'
import {Table, TableColumn, Pagination} from 'element-ui'
import CardLoading from '@/components/CardLoading.vue'
import {keywordsModule} from '@/store'

export default defineComponent({
  name: 'IndexPage',
  components: {
    [`${Table.name}`]: Table,
    [`${TableColumn.name}`]: TableColumn,
    [`${Pagination.name}`]: Pagination,
    CardLoading,
  },
  layout: 'admin',
  setup(_props) {
    const {loading, load} = keywordsModule.loader
    const keywords = computed(() => keywordsModule.searchedKeywords)

    onMounted(() => {
      load(loading, () => {
        keywordsModule.getSearchedKeywords()
      })
    })

    return {
      loading,
      keywords,
    }
  },
  head(): object {
    return {
      title: '検索ワード',
    }
  },
})
</script>

<style lang="postcss" scoped>
.container > * {
  margin-bottom: var(--spacing-4);
}

.title {
  font-size: 16px;
  font-weight: bold;
}

.title-header {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
}
</style>
