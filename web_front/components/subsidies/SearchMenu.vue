<template>
  <div v-loading="loading" class="container">
    <div class="search-title">補助金情報検索</div>
    <el-form class="form" :model="state" label-width="120px">
      <div class="search-item">
        <div class="search-label">検索</div>
        <el-input
          v-model="state.keyword"
          placeholder="フリーワード"
          clearable
        />
      </div>
      <div class="search-item">
        <div class="search-label">都道府県</div>
        <el-select
          v-if="prefectures.length > 0"
          v-model="state.prefectureId"
          placeholder="都道府県"
          clearable
          class="input-select"
          @change="selectPrefectureId"
        >
          <el-option
            v-for="prefecture in prefectures"
            :key="prefecture.id"
            :label="prefecture.name"
            :value="prefecture.id"
          />
        </el-select>
      </div>
      <div class="search-item">
        <div class="search-label">市長区村</div>
        <el-select
          v-if="prefectures.length > 0"
          v-model="state.cityIds"
          multiple
          clearable
          placeholder="市長区村"
          class="input-select"
          no-data-text="都道府県を選択してください"
        >
          <el-option
            v-for="city in cities"
            :key="city.id"
            :label="city.name"
            :value="city.id"
          />
        </el-select>
      </div>
      <div class="search-item">
        <div class="search-label">法人格</div>
        <el-select
          v-if="organizationTypes.length > 0"
          v-model="state.organizationType"
          placeholder="法人格"
          clearable
          class="input-select"
        >
          <el-option
            v-for="organizationType in organizationTypes"
            :key="organizationType.key"
            :label="organizationType.name"
            :value="organizationType.key"
          />
        </el-select>
      </div>
      <div class="search-item">
        <div class="search-label">業種</div>
        <el-select
          v-model="state.businessCategoryKeys"
          multiple
          placeholder="業種"
          :disabled="loading"
          class="category-select input-select"
        >
          <el-option
            v-for="businessCategory in businessCategoryKeys"
            :key="businessCategory.key"
            :label="businessCategory.name"
            :value="businessCategory.key"
          />
        </el-select>
      </div>
      <div class="search-item">
        <div class="search-label">従業員数</div>
        <el-input
          v-model="state.totalEmployee"
          class="input-left"
          type="number"
          placeholder="10"
        >
        </el-input>
        <span class="unit-font">人</span>
      </div>
      <div class="search-item">
        <div class="search-label">資本金</div>
        <el-input
          v-model="capitalMan"
          class="input-left"
          type="number"
          placeholder="100,000"
          @change="capitalChanged()"
        >
        </el-input>
        <span class="unit-font">万円</span>
      </div>
      <div class="search-item">
        <div class="search-label">年商</div>
        <el-input
          v-model="annualSalesMan"
          class="input-left"
          type="number"
          placeholder="1,000"
          @change="annualSalesChanged()"
        >
        </el-input>
        <span class="unit-font">万円</span>
      </div>
      <div class="search-item">
        <div class="search-label">創業日</div>
        <el-date-picker
          v-model="state.foundingDate"
          class="input-date"
          type="date"
          placeholder="日付"
        >
        </el-date-picker>
      </div>
      <div class="search-item">
        <el-checkbox v-model="state.inApplicationPeriod">
          募集期間中のみに絞る
        </el-checkbox>
      </div>
      <el-button class="search-button" type="primary" @click="search">
        以上の条件で検索
      </el-button>
    </el-form>
  </div>
</template>

<script lang="ts">
import {
  defineComponent,
  computed,
  onMounted,
  onUnmounted,
  useRoute,
  useRouter,
  reactive,
  ref,
  PropType,
} from '@nuxtjs/composition-api'
import {optionsModule, subsidiesModule, accountModule} from '@/store'
import {routingService} from '@/services/routingService'
import {SubsidySearchForm} from '@/types/Subsidy'
import {removeEmpty} from '@/utils/objectUtil'

export default defineComponent({
  name: 'SearchMenu',
  props: {
    onSearch: {
      type: Function as PropType<() => void>,
      required: false,
      default: () => {},
    },
  },
  setup(props) {
    const route = useRoute()
    const query = route.value.query
    const router = useRouter()
    const {loading, load} = subsidiesModule.loader
    const prefectures = computed(() => optionsModule.prefectures)
    const organizationTypes = computed(() => optionsModule.organizationTypes)
    const businessCategoryKeys = computed(
      () => optionsModule.businessCategories,
    )
    const selectPrefectureId = (prefectureId: number | null) => {
      if (prefectureId) {
        state.cityIds = []
        optionsModule.getCities(prefectureId)
      } else {
        state.prefectureId = null
      }
    }
    const cities = computed(() => optionsModule.cities)

    const state: SubsidySearchForm = reactive({
      prefectureId: null,
      cityIds: [],
      inApplicationPeriod: true,
      organizationType: null,
      businessCategoryKeys: [],
      totalEmployee: null,
      capital: null,
      keyword: '',
      foundingDate: null,
      annualSales: null,
    })
    const capitalMan = ref<number | null>(null)
    const capitalChanged = () => {
      if (capitalMan.value) {
        state.capital = capitalMan.value * 10000
      } else {
        state.capital = null
      }
    }
    const annualSalesMan = ref<number | null>(null)
    const annualSalesChanged = () => {
      if (annualSalesMan.value) {
        state.annualSales = annualSalesMan.value * 10000
      } else {
        state.annualSales = null
      }
    }

    const paramsFromCurrentCompany = (): Partial<SubsidySearchForm> => {
      const company = accountModule.currentCompany
      if (!company) {
        return {}
      }
      return {
        prefectureId: company.prefectureId,
        organizationType: company.organizationType,
        cityIds: [company.cityId],
        businessCategoryKeys: company.businessCategories,
        capital: company.capital,
        totalEmployee: company.totalEmployee,
        foundingDate: company.foundingDate
          ? new Date(company.foundingDate)
          : null,
        annualSales: company.annualSales,
      }
    }

    const paramsFromUrlQuery = (): Partial<SubsidySearchForm> => {
      const organizationType = query.organizationType?.toString()
      const prefectureIdQuery = Number(query.prefectureId)
      const prefectureId =
        isNaN(prefectureIdQuery) ||
        prefectureIdQuery === 0 ||
        prefectureIdQuery > 47
          ? null
          : prefectureIdQuery
      const cityIds = query.cityIds?.toString().split('|').map(Number)
      const businessCategoryKeys = query.businessCategoryKeys
        ?.toString()
        .split('|')
      const inApplicationPeriod = query.inApplicationPeriod !== 'false'
      const keyword = query.keyword?.toString()
      const capital = query.capital ? Number(query.capital) : null
      const totalEmployee = query.totalEmployee
        ? Number(query.totalEmployee)
        : null
      const foundingDate = query.foundingDate
        ? new Date(query.foundingDate.toString())
        : null
      const annualSales = query.annualSales ? Number(query.annualSales) : null

      return removeEmpty({
        organizationType,
        cityIds,
        prefectureId,
        inApplicationPeriod,
        businessCategoryKeys,
        capital,
        totalEmployee,
        keyword,
        foundingDate,
        annualSales,
      })
    }

    const search = () => {
      subsidiesModule.setSearchParams(state)
      load(loading, () => {
        router.push({path: routingService.Top(), query: urlQueryFromParams()})
        subsidiesModule.getSubsidies()
        props.onSearch()
      })
    }

    const urlQueryFromParams = () => {
      const params = removeEmpty(subsidiesModule.searchParams)
      if (params.inApplicationPeriod === true) {
        params.inApplicationPeriod = undefined
      }
      const company = accountModule.currentCompany
      if (!company) {
        return params
      }
      if (params.organizationType === company.organizationType) {
        params.organizationType = undefined
      }
      if (params.prefectureId === company.prefectureId.toString()) {
        params.prefectureId = undefined
      }
      if (params.cityIds === company.cityId.toString()) {
        params.cityIds = []
      }
      if (
        params.businessCategoryKeys === company.businessCategories.join('|')
      ) {
        params.businessCategoryKeys = []
      }
      if (params.capital === company.capital) {
        params.capital = undefined
      }
      if (params.totalEmployee === company.totalEmployee) {
        params.totalEmployee = undefined
      }
      if (params.foundingDate === company.foundingDate) {
        params.foundingDate = undefined
      }
      if (params.annualSales === company.annualSales) {
        params.annualSales = undefined
      }
      return params
    }

    onMounted(() => {
      load(loading, async () => {
        optionsModule.getOrganizationTypes()
        optionsModule.getBusinessCategories()
        optionsModule.getPrefectures()
        await accountModule.getCurrentUser()
        Object.assign(state, paramsFromCurrentCompany())
        Object.assign(state, paramsFromUrlQuery())
        if (state.prefectureId) {
          optionsModule.getCities(state.prefectureId)
        }
        if (state.prefectureId !== accountModule.currentCompany?.prefectureId) {
          state.cityIds = []
        }
        if (state.capital) {
          capitalMan.value = state.capital / 10000
        }
        if (state.annualSales) {
          annualSalesMan.value = state.annualSales / 10000
        }
        subsidiesModule.setSearchParams(state)
        const pageQuery = route.value.query.page?.toString() || null
        const page = pageQuery ? Number(pageQuery) : 1
        await subsidiesModule.getSubsidies(page)
      })
    })

    onUnmounted(() => {
      subsidiesModule.setSubsidies([])
      optionsModule.setCities([])
    })

    return {
      loading,
      prefectures,
      selectPrefectureId,
      organizationTypes,
      businessCategoryKeys,
      cities,
      state,
      search,
      capitalMan,
      capitalChanged,
      annualSalesMan,
      annualSalesChanged,
    }
  },
})
</script>

<style lang="postcss" scoped>
.container {
  padding: var(--spacing-4);
}

.search-title {
  font-size: 16px;
  font-weight: bold;
}

.search-item {
  margin: var(--spacing-4) 0;
}

.search-label {
  font-size: 14px;
  margin-bottom: var(--spacing-2);
}

.search-button {
  width: 100%;
}

.input-date {
  width: 100%;
}

.input-left {
  width: 80%;
}

.input-select {
  width: 100%;
}

.unit-font {
  font-size: 14px;
}
</style>
