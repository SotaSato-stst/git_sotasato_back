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
        <el-radio-button
          v-for="option in publishingCodeOptions"
          :key="option.label"
          :label="option.label"
        >
          {{ option.text }}
        </el-radio-button>
      </el-radio-group>

      <el-select
        v-model="filter.subsidyCategory"
        size="mini"
        class="search-input"
        @change="selectSubsidyCategoryFilter"
      >
        <el-option
          v-for="item in subsidyCategoryOptions"
          :key="item.value"
          :label="item.label"
          :value="item.value"
        ></el-option>
      </el-select>

      <el-select
        v-model="filter.ministryId"
        placeholder="省庁"
        size="mini"
        class="search-input"
        clearable
        @change="selectMinistryIdFilter"
      >
        <el-option
          v-for="ministry in ministries"
          :key="ministry.id"
          :label="ministry.name"
          :value="ministry.id"
        />
      </el-select>

      <el-select
        v-model="filter.sortingCode"
        size="mini"
        class="search-input"
        @change="selectSortSubsidy"
      >
        <el-option
          v-for="item in sortSubsidyOptions"
          :key="item.value"
          :label="item.label"
          :value="item.value"
        ></el-option>
      </el-select>
    </div>

    <div class="filter">
      <el-input
        v-model="filter.keyword"
        placeholder="タイトル・詳細"
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
      <el-table-column label="タイトル" min-width="200">
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
      <el-table-column label="上限金額" width="120">
        <template slot-scope="scope">
          {{ convertToShortJPY(scope.row.priceMax) }}円
        </template>
      </el-table-column>
      <el-table-column prop="startFrom" label="申請期限" width="100">
        <template slot-scope="scope">
          {{ scope.row.endTo }}
        </template>
      </el-table-column>
      <el-table-column prop="rankingScore" label="点" width="50" />
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
import {optionsModule, adminSubsidiesModule} from '@/store'
import {routingService} from '@/services/routingService'
import {
  Subsidy,
  AdminSubsidyIndexParams,
  FilterPublishingType,
  FilterSubsidyCategoryType,
  SortSubsidyType,
  PublishingCodeOption,
  SortSubsidyOption,
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
  layout: ctx => (ctx.$device.isMobile ? 'admin-mobile' : 'admin'),
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
      subsidyCategory: 'all',
      sortingCode: 'all',
      ministryId: null,
    })
    const endAfter = ref<Date | null>(null)

    const getPage = (page: number) => {
      adminSubsidiesModule.setSubsidies([])
      requestData({page})
    }

    const selectPublishingFilter = (publishingCode: FilterPublishingType) => {
      requestData({publishingCode, page: 1})
    }

    const selectSortSubsidy = (sortingCode: SortSubsidyType) => {
      requestData({sortingCode, page: 1})
    }

    const selectSubsidyCategoryFilter = (
      subsidyCategory: FilterSubsidyCategoryType,
    ) => {
      requestData({subsidyCategory, page: 1})
    }

    const selectMinistryIdFilter = (ministryId: number) => {
      requestData({ministryId, page: 1})
    }

    const ministries = computed(() => optionsModule.ministries)

    const selectEndAfter = (date: Date | null) => {
      filter.endAfter = date?.toLocaleDateString() || null
    }

    const search = () => {
      requestData({
        endAfter: filter.endAfter,
        keyword: filter.keyword,
        page: 1,
      })
    }

    const requestData = (segueFilter: Partial<AdminSubsidyIndexParams>) => {
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

    const publishingCodeOptions: PublishingCodeOption[] = [
      {label: 'all', text: 'すべて'},
      {label: 'published', text: '公開済'},
      {label: 'editing', text: '編集中'},
      {label: 'archived', text: 'アーカイブ'},
    ]
    const subsidyCategoryOptions = [
      {
        label: '全ての種別',
        value: 'all',
      },
      {
        label: '補助金',
        value: 'hojo',
      },
      {
        label: '助成金',
        value: 'josei',
      },
      {
        label: '給付金',
        value: 'kyufu',
      },
    ]

    const sortSubsidyOptions: SortSubsidyOption[] = [
      {
        label: '更新順',
        value: 'all',
      },
      {
        label: 'ランキング順',
        value: 'ranking',
      },
      {
        label: '金額順',
        value: 'price',
      },
      {
        label: '締切順',
        value: 'end',
      },
    ]

    onMounted(() => {
      load(loading, () => {
        optionsModule.getMinistries()
        const page = convertQueryNumber(query.page) || 1
        const publishingCode = (convertQueryString(query.publishingCode) ||
          'all') as FilterPublishingType
        const subsidyCategory = (convertQueryString(query.subsidyCategory) ||
          'all') as FilterSubsidyCategoryType
        const sortingCode = (convertQueryString(query.sortingCode) ||
          'all') as SortSubsidyType
        const endAfterDate = convertQueryDate(query.endAfter) || null
        endAfter.value = endAfterDate
        const keyword = query.keyword?.toString() || ''
        requestData({
          page,
          publishingCode,
          endAfter: endAfterDate?.toLocaleDateString(),
          keyword,
          subsidyCategory,
          sortingCode,
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
      selectSubsidyCategoryFilter,
      publishingCodeOptions,
      subsidyCategoryOptions,
      selectSortSubsidy,
      sortSubsidyOptions,
      ministries,
      selectMinistryIdFilter,
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
  overflow: scroll;
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
  color: var(--text-font-color);
}
</style>

<style>
.el-table table {
  width: 100%;
}
</style>
