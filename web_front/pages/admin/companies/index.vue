<template>
  <div class="container">
    <card-loading :loading="loading" />
    <el-table v-if="!loading" :data="companies" stripe style="width: 100%">
      <el-table-column prop="name" label="会社名" />
      <el-table-column prop="adress" label="住所" />
      <el-table-column prop="businessCategories" label="業種">
        <template slot-scope="scope">
          <span>{{
            scope.row.businessCategories.map(c => c.name).join(',')
          }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="capital" label="資本金" width="120">
        <template slot-scope="scope">
          {{ convertToShortJPY(scope.row.capital) }}
        </template>
      </el-table-column>
      <el-table-column prop="totalEmployee" label="従業員数" width="120">
        <template slot-scope="scope">
          {{ scope.row.totalEmployee }}人
        </template>
      </el-table-column>
      <el-table-column label="操作" width="100">
        <template slot-scope="scope">
          <el-button size="mini" @click="handleEdit(scope.row)">編集</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      v-if="companies.length > 0"
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
import {
  computed,
  defineComponent,
  onMounted,
  useRouter,
} from '@nuxtjs/composition-api'
import {Table, TableColumn, Pagination} from 'element-ui'
import CardLoading from '@/components/CardLoading.vue'
import {companiesModule} from '@/store'
import {useLoader} from '@/services/useLoader'
import {routingService} from '@/services/routingService'
import {Company} from '@/types/Company'
import {convertToShortJPY} from '@/utils/numberFormatter'

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
    const router = useRouter()
    const {loading, load} = useLoader()
    const companies = computed(() => companiesModule.companies)
    const pagination = computed(() => companiesModule.pagination)

    const handleEdit = (company: Company) => {
      router.push(routingService.AdminCompanyDetail(company.id))
    }

    onMounted(() => {
      load(loading, () => {
        companiesModule.getCompanies()
      })
    })

    return {
      loading,
      companies,
      pagination,
      handleEdit,
      convertToShortJPY,
    }
  },
})
</script>

<style lang="postcss" scoped>
.container > * {
  margin-bottom: var(--spacing-4);
}
</style>
