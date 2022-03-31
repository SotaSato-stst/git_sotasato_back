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
          v-model="state.cityId"
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
          v-model="state.businessCategories"
          multiple
          placeholder="業種"
          :disabled="loading"
          class="category-select input-select"
        >
          <el-option
            v-for="businessCategory in businessCategories"
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
          format="yyyy-MM-dd"
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
  watch,
  ref,
  PropType,
} from '@nuxtjs/composition-api'
import {optionsModule, subsidiesModule, accountModule} from '@/store'
import {routingService} from '@/services/routingService'
import {SubsidySearchForm} from '@/types/Subsidy'
import {removeEmpty, removeSameValue} from '@/utils/objectUtil'
import {
  convertQueryString,
  convertQueryNumber,
  convertQueryArray,
  convertQueryDate,
} from '@/utils/urlQuery'

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
    const businessCategories = computed(() => optionsModule.businessCategories)
    const selectPrefectureId = (prefectureId: number | null) => {
      if (prefectureId) {
        state.cityId = null
        optionsModule.getCities(prefectureId)
      } else {
        state.prefectureId = null
      }
    }
    const cities = computed(() => optionsModule.cities)

    const state: SubsidySearchForm = reactive({
      prefectureId: null,
      cityId: null,
      inApplicationPeriod: true,
      organizationType: null,
      businessCategories: [],
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

    const search = () => {
      subsidiesModule.setSearchParams(state)
      load(loading, () => {
        router.push({path: routingService.Top(), query: urlQueryFromParams()})
        subsidiesModule.getSubsidies()
        props.onSearch()
      })
    }

    const paramsFromCurrentCompany = (): Partial<SubsidySearchForm> => {
      const company = accountModule.currentCompany
      if (!company) {
        return {}
      }
      return {
        prefectureId: company.prefectureId,
        organizationType: company.organizationType,
        cityId: company.cityId,
        businessCategories: company.businessCategories,
        capital: company.capital,
        totalEmployee: company.totalEmployee,
        foundingDate: company.foundingDate
          ? new Date(company.foundingDate)
          : null,
        annualSales: company.annualSales,
      }
    }

    const paramsFromUrlQuery = (): Partial<SubsidySearchForm> => {
      const organizationType = convertQueryString(query.organizationType)
      const prefectureId = convertQueryNumber(query.prefectureId)
      const cityId = convertQueryNumber(query.cityId)
      const businessCategories =
        convertQueryArray(query.businessCategories) || undefined
      const inApplicationPeriod = query.inApplicationPeriod !== 'false'
      const keyword = convertQueryString(query.keyword) || undefined
      const capital = convertQueryNumber(query.capital)
      const totalEmployee = convertQueryNumber(query.totalEmployee)
      const foundingDate = convertQueryDate(query.foundingDate)
      const annualSales = convertQueryNumber(query.annualSales)

      return removeEmpty({
        organizationType,
        cityId,
        prefectureId,
        inApplicationPeriod,
        businessCategories,
        capital,
        totalEmployee,
        keyword,
        foundingDate,
        annualSales,
      })
    }

    const urlQueryFromParams = () => {
      const company = accountModule.currentCompany
      if (!company) {
        return {}
      }
      const foundingDate = company.foundingDate
        ? new Date(company.foundingDate).toLocaleDateString()
        : subsidiesModule.searchParams.foundingDate
      return removeSameValue(subsidiesModule.searchParams, {
        ...company,
        prefectureId: company.prefectureId.toString(),
        cityId: company.cityId.toString(),
        keyword: '',
        inApplicationPeriod: true,
        foundingDate,
      })
    }

    watch(
      () => state.prefectureId,
      (prefectureId, prev) => {
        if (prefectureId && !prev) {
          optionsModule.getCities(prefectureId)
        }
      },
    )

    onMounted(() => {
      load(loading, async () => {
        optionsModule.getOrganizationTypes()
        optionsModule.getBusinessCategories()
        optionsModule.getPrefectures()
        await accountModule.getCurrentUser()
        Object.assign(state, paramsFromCurrentCompany())
        Object.assign(state, paramsFromUrlQuery())
        if (state.capital) {
          capitalMan.value = state.capital / 10000
        }
        if (state.annualSales) {
          annualSalesMan.value = state.annualSales / 10000
        }
        subsidiesModule.setSearchParams(state)
        const page = convertQueryNumber(route.value.query.page) || 1
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
      businessCategories,
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
