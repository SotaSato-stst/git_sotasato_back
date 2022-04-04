<template>
  <div class="container">
    <div class="title-header">
      <div class="title">家庭向け給付金 一覧</div>
      <el-button type="primary" @click="newBenefitPage()">
        新規給付金情報追加
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
        v-model="filter.sortingCode"
        size="mini"
        class="search-input"
        @change="selectSortBenefit"
      >
        <el-option
          v-for="item in sortBenefitOptions"
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
    <el-table v-if="!loading" :data="benefits" stripe style="width: 100%">
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
      <el-table-column label="地域" width="120">
        <template slot-scope="scope">
          <span v-if="scope.row.prefecture">{{
            scope.row.prefecture.name
          }}</span>
          <span v-if="!scope.row.prefecture">全国</span>
          <span v-if="scope.row.city">{{ scope.row.city.name }}</span>
          <span v-if="!scope.row.city">全域</span>
        </template>
      </el-table-column>
      <el-table-column prop="startFrom" label="申請期限" width="100">
        <template slot-scope="scope">
          {{ scope.row.endDate }}
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
      v-if="benefits.length > 0 && !loading"
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
import {optionsModule, adminBenefitsModule} from '@/store'
import {routingService} from '@/services/routingService'
import {
  Benefit,
  AdminBenefitIndexParams,
  FilterPublishingType,
  SortBenefitType,
  PublishingCodeOption,
  SortBenefitOption,
} from '@/types/Benefit'
import {convertToJpDate} from '@/utils/dateFormatter'
import {publishingCodeLabel, publishingCodeType} from '@/utils/enumKeyToName'
import {removeEmpty} from '@/utils/objectUtil'
import {
  convertQueryNumber,
  convertQueryString,
  convertQueryDate,
} from '@/utils/urlQuery'

export default defineComponent({
  name: 'AdminBenefitIndex',
  components: {
    Pagination,
    CardLoading,
  },
  layout: 'admin',
  setup(_props) {
    const router = useRouter()
    const route = useRoute()
    const query = route.value.query
    const {loading, load} = adminBenefitsModule.loader
    const benefits = computed(() => adminBenefitsModule.benefits)
    const pagination = computed(() => adminBenefitsModule.pagination)
    const filter = reactive<AdminBenefitIndexParams>({
      page: 1,
      publishingCode: 'all',
      endAfter: null,
      keyword: null,
      sortingCode: 'all',
    })
    const endAfter = ref<Date | null>(null)

    const getPage = (page: number) => {
      adminBenefitsModule.setBenefits([])
      requestData({page})
    }

    const selectPublishingFilter = (publishingCode: FilterPublishingType) => {
      requestData({publishingCode, page: 1})
    }

    const selectSortBenefit = (sortingCode: SortBenefitType) => {
      requestData({sortingCode, page: 1})
    }

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

    const requestData = (segueFilter: Partial<AdminBenefitIndexParams>) => {
      Object.assign(filter, segueFilter)
      router.push({query: {...removeEmpty(filter)}})
      adminBenefitsModule.getBenefits(filter)
    }

    const handleEdit = (benefit: Benefit) => {
      router.push(routingService.AdminBenefitDetail(benefit.id))
    }
    const newBenefitPage = () => {
      router.push(routingService.AdminNewBenefit())
    }

    const publishingCodeOptions: PublishingCodeOption[] = [
      {label: 'all', text: 'すべて'},
      {label: 'published', text: '公開済'},
      {label: 'editing', text: '編集中'},
      {label: 'archived', text: 'アーカイブ'},
    ]

    const sortBenefitOptions: SortBenefitOption[] = [
      {
        label: '更新順',
        value: 'all',
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
        const sortingCode = (convertQueryString(query.sortingCode) ||
          'all') as SortBenefitType
        const endAfterDate = convertQueryDate(query.endAfter) || null
        endAfter.value = endAfterDate
        const keyword = query.keyword?.toString() || ''
        requestData({
          page,
          publishingCode,
          endAfter: endAfterDate?.toLocaleDateString(),
          keyword,
          sortingCode,
        })
      })
    })

    return {
      loading,
      benefits,
      pagination,
      filter,
      endAfter,
      search,
      getPage,
      handleEdit,
      newBenefitPage,
      convertToJpDate,
      publishingCodeLabel,
      publishingCodeType,
      selectPublishingFilter,
      selectEndAfter,
      publishingCodeOptions,
      selectSortBenefit,
      sortBenefitOptions,
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
  flex-wrap: wrap;
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
