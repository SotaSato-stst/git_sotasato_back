<template>
  <div class="container">
    <div class="title-header">
      <div class="title">会社 一覧</div>
      <el-button type="primary" @click="newCompanyPage()">
        新規会社追加
      </el-button>
    </div>
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
    <pagination
      v-if="companies.length > 0 && !loading"
      :pagination="pagination"
      :request-page="getPage"
    />
  </div>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  onMounted,
  useRoute,
  useRouter,
} from '@nuxtjs/composition-api'
import CardLoading from '@/components/CardLoading.vue'
import Pagination from '@/components/Pagination.vue'
import {companiesModule} from '@/store'
import {routingService} from '@/services/routingService'
import {Company} from '@/types/Company'
import {convertToShortJPY} from '@/utils/numberFormatter'

export default defineComponent({
  name: 'IndexPage',
  components: {
    Pagination,
    CardLoading,
  },
  layout: 'admin',
  setup(_props) {
    const router = useRouter()
    const route = useRoute()
    const {loading, load} = companiesModule.loader
    const companies = computed(() => companiesModule.companies)
    const pagination = computed(() => companiesModule.pagination)
    const getPage = (page: number) => {
      companiesModule.setCompanies([])
      companiesModule.getCompanies(page)
    }
    const handleEdit = (company: Company) => {
      router.push(routingService.AdminCompanyDetail(company.id))
    }
    const newCompanyPage = () => {
      router.push(routingService.AdminNewCompany())
    }

    onMounted(() => {
      load(loading, () => {
        const pageQuery = route.value.query.page?.toString() || null
        const page = pageQuery ? Number(pageQuery) : 1
        companiesModule.getCompanies(page)
      })
    })

    return {
      loading,
      companies,
      pagination,
      getPage,
      handleEdit,
      newCompanyPage,
      convertToShortJPY,
    }
  },
  head(): object {
    return {
      title: '会社管理',
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
