<template>
  <div class="container">
    <div class="title-header">
      <div class="title">補助金情報 一覧</div>
      <el-button type="primary" @click="newSubsidyPage()">
        新規補助金情報追加
      </el-button>
    </div>
    <div class="filter">
      <el-radio-group
        v-model="filter.publishingFilter"
        size="mini"
        @change="selectPublishingFilter"
      >
        <el-radio-button label="all">すべて</el-radio-button>
        <el-radio-button label="published">公開済</el-radio-button>
        <el-radio-button label="editing">編集中</el-radio-button>
        <el-radio-button label="archived">アーカイブ</el-radio-button>
      </el-radio-group>
      <div class="total-count">{{ pagination.itemsTotal }}件</div>
    </div>
    <card-loading :loading="loading" />
    <el-table v-if="!loading" :data="subsidies" stripe style="width: 100%">
      <el-table-column label="公開状況" width="100" align="center">
        <template slot-scope="scope">
          <el-tag
            :type="publishingCodeType(scope.row.publishingCode)"
            effect="dark"
            size="mini"
          >
            {{ publishingCodeLabel(scope.row.publishingCode) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="タイトル">
        <template slot-scope="scope">
          <a class="detail-link" @click="handleEdit(scope.row)">{{
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
    <pagination
      v-if="subsidies.length > 0 && !loading"
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
  reactive,
} from '@nuxtjs/composition-api'
import {Table, TableColumn, Tag, RadioGroup, RadioButton} from 'element-ui'
import CardLoading from '@/components/CardLoading.vue'
import Pagination from '@/components/Pagination.vue'
import {adminSubsidiesModule} from '@/store'
import {routingService} from '@/services/routingService'
import {
  Subsidy,
  AdminSubsidyIndexParams,
  FilterPublishingType,
} from '@/types/Subsidy'
import {convertToShortJPY} from '@/utils/numberFormatter'
import {publishingCodeLabel, publishingCodeType} from '@/utils/enumKeyToName'
import {removeEmpty} from '@/utils/objectUtil'

export default defineComponent({
  name: 'AdminSubsidyIndex',
  components: {
    [`${Table.name}`]: Table,
    [`${TableColumn.name}`]: TableColumn,
    [`${Tag.name}`]: Tag,
    [`${RadioGroup.name}`]: RadioGroup,
    [`${RadioButton.name}`]: RadioButton,
    Pagination,
    CardLoading,
  },
  layout: 'admin',
  setup(_props) {
    const router = useRouter()
    const route = useRoute()
    const {loading, load} = adminSubsidiesModule.loader
    const subsidies = computed(() => adminSubsidiesModule.subsidies)
    const pagination = computed(() => adminSubsidiesModule.pagination)
    const filter = reactive<AdminSubsidyIndexParams>({
      page: 1,
      publishingFilter: 'all',
    })

    const getPage = (page: number) => {
      adminSubsidiesModule.setSubsidies([])
      handleSegue({page})
    }

    const selectPublishingFilter = (publishingFilter: FilterPublishingType) => {
      handleSegue({publishingFilter, page: 1})
    }

    const handleSegue = (segueFilter: Partial<AdminSubsidyIndexParams>) => {
      Object.assign(filter, segueFilter)
      router.push({query: {...removeEmpty(filter)}})
      adminSubsidiesModule.getSubsidies(filter)
    }

    const handleEdit = (subsidy: Subsidy) => {
      router.push(routingService.AdminSubsidyDetail(subsidy.id))
    }
    const newSubsidyPage = () => {
      router.push(routingService.AdminNewSubsidy())
    }

    onMounted(() => {
      load(loading, () => {
        const pageQuery = route.value.query.page?.toString() || null
        const page = pageQuery ? Number(pageQuery) : 1
        const publishingFilter =
          (route.value.query.publishingFilter?.toString() as FilterPublishingType) ||
          'all'
        handleSegue({page, publishingFilter})
      })
    })

    return {
      loading,
      subsidies,
      pagination,
      filter,
      getPage,
      handleEdit,
      newSubsidyPage,
      convertToShortJPY,
      publishingCodeLabel,
      publishingCodeType,
      selectPublishingFilter,
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
  cursor: pointer;
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

.filter {
  display: flex;
  align-items: center;
}

.filter > * {
  margin-right: var(--spacing-4);
}
</style>
