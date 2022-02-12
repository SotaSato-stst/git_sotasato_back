<template>
  <div class="container">
    <div class="title-header">
      <div class="title">補助金情報 一覧</div>
      <el-button type="primary" @click="newSubsidyPage()">
        新規補助金情報追加
      </el-button>
    </div>
    <card-loading :loading="loading" />
    <el-table v-if="!loading" :data="subsidies" stripe style="width: 100%">
      <el-table-column label="公開状況" width="90" align="center">
        <template slot-scope="scope">
          <el-tag
            :type="scope.row.publishingCode == 'published' ? 'success' : 'info'"
            effect="dark"
            size="mini"
          >
            {{ publishingCodeLabel(scope.row.publishingCode) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="タイトル">
        <template slot-scope="scope">
          <a class="detail-link" :href="detailPath(scope.row.id)">{{
            scope.row.title
          }}</a>
        </template>
      </el-table-column>
      <el-table-column label="URL" width="160">
        <template slot-scope="scope">
          <a
            class="detail-link"
            :href="scope.row.url"
            target="_blank"
            style="word-break: keep-all"
          >
            {{ scope.row.url }}
          </a>
        </template>
      </el-table-column>
      <el-table-column label="発行機関" width="110">
        <template slot-scope="scope">
          <span v-if="scope.row.ministry">{{ scope.row.ministry.name }}</span>
          <span v-if="scope.row.prefecture">{{
            scope.row.prefecture.name
          }}</span>
          <span v-if="scope.row.city">{{ scope.row.city.name }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="businessCategories" label="業種" width="210">
        <template slot-scope="scope">
          <span>{{
            scope.row.businessCategories.map(c => c.name).join(',')
          }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="priceMax" label="最大支援金額" width="120">
        <template slot-scope="scope">
          {{ convertToShortJPY(scope.row.priceMax) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="90" align="center">
        <template slot-scope="scope">
          <el-button size="mini" @click="handleEdit(scope.row)">編集</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      v-if="subsidies.length > 0 && !loading"
      background
      layout="prev, pager, next"
      :page-count="pagination.totalPages"
      :total="pagination.itemsTotal"
      :page-size="pagination.itemsPerPage"
      :current-page="pagination.currentPage"
      @current-change="getPage"
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
import {Table, TableColumn, Pagination, Tag} from 'element-ui'
import CardLoading from '@/components/CardLoading.vue'
import {adminSubsidiesModule} from '@/store'
import {routingService} from '@/services/routingService'
import {Subsidy} from '@/types/Subsidy'
import {convertToShortJPY} from '@/utils/numberFormatter'
import {publishingCodeLabel} from '@/utils/enumKeyToName'

export default defineComponent({
  name: 'AdminSubsidyIndex',
  components: {
    [`${Table.name}`]: Table,
    [`${TableColumn.name}`]: TableColumn,
    [`${Pagination.name}`]: Pagination,
    [`${Tag.name}`]: Tag,
    CardLoading,
  },
  layout: 'admin',
  setup(_props) {
    const router = useRouter()
    const {loading, load} = adminSubsidiesModule.loader
    const subsidies = computed(() => adminSubsidiesModule.subsidies)
    const pagination = computed(() => adminSubsidiesModule.pagination)

    const getPage = (page: number) => {
      adminSubsidiesModule.setSubsidies([])
      adminSubsidiesModule.getSubsidies(page)
    }

    const detailPath = (id: number) => {
      return routingService.AdminSubsidyDetail(id)
    }
    const handleEdit = (subsidy: Subsidy) => {
      router.push(detailPath(subsidy.id))
    }
    const newSubsidyPage = () => {
      router.push(routingService.AdminNewSubsidy())
    }

    onMounted(() => {
      load(loading, () => {
        adminSubsidiesModule.getSubsidies()
      })
    })

    return {
      loading,
      subsidies,
      pagination,
      getPage,
      detailPath,
      handleEdit,
      newSubsidyPage,
      convertToShortJPY,
      publishingCodeLabel,
    }
  },
  head(): object {
    return {
      title: '補助金情報管理',
    }
  },
})
</script>

<style lang="postcss" scoped>
.container > * {
  margin-bottom: var(--spacing-4);
}

.detail-link {
  color: var(--primary-color);
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
