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
        v-model="filter.publishingCode"
        size="mini"
        @change="selectPublishingFilter"
      >
        <el-radio-button label="all">すべて</el-radio-button>
        <el-radio-button label="published">公開済</el-radio-button>
        <el-radio-button label="editing">編集中</el-radio-button>
        <el-radio-button label="archived">アーカイブ</el-radio-button>
      </el-radio-group>
      <el-input
        v-model="filter.keyword"
        placeholder="タイトル"
        size="mini"
        class="search-input"
      />
      <div>
        <el-date-picker
          v-model="endAfter"
          type="date"
          size="mini"
          class="search-input"
          placeholder="締切日"
          @change="selectEndAfter"
        />
        <span class="input-caption">以降に締切</span>
      </div>
      <el-button class="search-button" @click="search">検索</el-button>
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
      <el-table-column prop="subsidyCategory" label="種類" width="70">
        <template slot-scope="scope">
          <span>{{ subsidyCategoryLabel(scope.row.subsidyCategory) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="タイトル">
        <template slot-scope="scope">
          <a class="detail-link" @click="handleEdit(scope.row)">{{
            scope.row.title
          }}</a>
        </template>
      </el-table-column>
      <el-table-column label="発行機関" width="120">
        <template slot-scope="scope">
          <div v-if="scope.row.ministry">{{ scope.row.ministry.name }}</div>
          <div v-if="scope.row.prefecture">{{ scope.row.prefecture.name }}</div>
          <div v-if="scope.row.city">{{ scope.row.city.name }}</div>
        </template>
      </el-table-column>
      <el-table-column prop="startFrom" label="申請期限" width="100">
        <template slot-scope="scope">
          {{ scope.row.endTo }}
        </template>
      </el-table-column>
      <el-table-column label="URL" width="180">
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
  ref,
} from '@nuxtjs/composition-api'
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
import {convertToJpDate} from '@/utils/dateFormatter'
import {
  publishingCodeLabel,
  publishingCodeType,
  subsidyCategoryLabel,
} from '@/utils/enumKeyToName'
import {removeEmpty} from '@/utils/objectUtil'
import {
  convertQueryNumber,
  convertQueryString,
  convertQueryDate,
} from '@/utils/urlQuery'

export default defineComponent({
  name: 'AdminSubsidyIndex',
  components: {
    Pagination,
    CardLoading,
  },
  layout: 'admin',
  setup(_props) {
    const router = useRouter()
    const route = useRoute()
    const query = route.value.query
    const {loading, load} = adminSubsidiesModule.loader
    const subsidies = computed(() => adminSubsidiesModule.subsidies)
    const pagination = computed(() => adminSubsidiesModule.pagination)
    const filter = reactive<AdminSubsidyIndexParams>({
      page: 1,
      publishingCode: 'all',
      endAfter: null,
      keyword: null,
    })
    const endAfter = ref<Date | null>(null)

    const getPage = (page: number) => {
      adminSubsidiesModule.setSubsidies([])
      handleSegue({page})
    }

    const selectPublishingFilter = (publishingCode: FilterPublishingType) => {
      handleSegue({publishingCode, page: 1})
    }

    const selectEndAfter = (date: Date | null) => {
      filter.endAfter = date?.toLocaleDateString() || null
    }

    const search = () => {
      handleSegue({endAfter: filter.endAfter, keyword: filter.keyword, page: 1})
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
        const page = convertQueryNumber(query.page) || 1
        const publishingCode = (convertQueryString(query.publishingCode) ||
          'all') as FilterPublishingType
        const endAfterDate = convertQueryDate(query.endAfter) || null
        endAfter.value = endAfterDate
        const keyword = query.keyword?.toString() || ''
        handleSegue({
          page,
          publishingCode,
          endAfter: endAfterDate?.toLocaleDateString(),
          keyword,
        })
      })
    })

    return {
      loading,
      subsidies,
      pagination,
      filter,
      endAfter,
      search,
      getPage,
      handleEdit,
      newSubsidyPage,
      convertToShortJPY,
      convertToJpDate,
      publishingCodeLabel,
      publishingCodeType,
      subsidyCategoryLabel,
      selectPublishingFilter,
      selectEndAfter,
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

.search-input {
  width: 130px;
}

.search-button {
  height: 28px;
  padding: var(--spacing-1) var(--spacing-4);
}

.input-caption {
  font-size: 12px;
  color: var(--primary-font-color);
}
</style>

<style>
.el-table table {
  width: 100%;
}
</style>
