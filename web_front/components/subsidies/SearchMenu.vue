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
        <div class="search-label">業種</div>
        <el-select
          v-model="state.businessCategoryKeys"
          multiple
          placeholder="業種"
          :disabled="loading"
          class="category-select"
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
          class="input-number input-left"
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
          class="input-number input-left"
          type="number"
          placeholder="100,000"
          @change="capitalChanged()"
        >
        </el-input>
        <span class="unit-font">万円</span>
      </div>
      <div class="search-item">
        <div class="search-label">創業日</div>
        <el-date-picker
          v-model="state.foundingDate"
          class="input-number input-left"
          type="date"
          placeholder="日付"
        >
        </el-date-picker>
      </div>
      <div class="search-item">
        <div class="search-label">年商</div>
        <el-input
          v-model="state.annualSales"
          class="input-number input-left"
          type="number"
          placeholder="10,000,000"
        >
        </el-input>
        <span class="unit-font">万円</span>
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
} from '@nuxtjs/composition-api'
import {Form, FormItem, Input, Button, Checkbox, InputNumber} from 'element-ui'
import {optionsModule, subsidiesModule, accountModule} from '@/store'
import {routingService} from '@/services/routingService'
import {SubsidySearchForm} from '@/types/Subsidy'
import {removeEmpty} from '@/utils/objectUtil'

export default defineComponent({
  name: 'SearchMenu',
  components: {
    [`${Form.name}`]: Form,
    [`${FormItem.name}`]: FormItem,
    [`${Input.name}`]: Input,
    [`${Button.name}`]: Button,
    [`${Checkbox.name}`]: Checkbox,
    [`${InputNumber.name}`]: InputNumber,
  },
  setup(_props) {
    const route = useRoute()
    const query = route.value.query
    const router = useRouter()
    const {loading, load} = subsidiesModule.loader
    const prefectures = computed(() => optionsModule.prefectures)
    const businessCategoryKeys = computed(
      () => optionsModule.businessCategories,
    )
    const selectPrefectureId = (prefectureId: number | null) => {
      if (prefectureId) {
        optionsModule.getCities(prefectureId)
      }
    }
    const cities = computed(() => optionsModule.cities)

    const state: SubsidySearchForm = reactive({
      prefectureId: null,
      cityIds: [],
      inApplicationPeriod: true,
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
      }
    }

    const paramsFromCurrentCompany = (): Partial<SubsidySearchForm> => {
      const company = accountModule.currentCompany
      if (!company) {
        return {}
      }
      return {
        prefectureId: company.prefectureId,
        cityIds: [company.cityId],
        businessCategoryKeys: company.businessCategories,
        capital: company.capital,
        totalEmployee: company.totalEmployee,
        foundingDate: company.foundingDate,
        annualSales: company.annualSales,
      }
    }

    const paramsFromUrlQuery = () => {
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
      const capital = query.capital?.toString()
      const totalEmployee = query.totalEmployee?.toString()
      const foundingDate = query.foundingDate?.toString()
      const annualSales = query.annualSales?.toString()

      return removeEmpty({
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
      })
    }

    const urlQueryFromParams = () => {
      const params = removeEmpty(subsidiesModule.searchParams)
      if (params.inApplicationPeriod === true) {
        params.inApplicationPeriod = undefined
      }
      const company = accountModule.currentCompany
      if (params.prefectureId === company?.prefectureId.toString()) {
        params.prefectureId = undefined
      }
      if (params.cityIds === company?.cityId.toString()) {
        params.cityIds = []
      }
      if (
        params.businessCategoryKeys === company?.businessCategories.join('|')
      ) {
        params.businessCategoryKeys = []
      }
      if (params.capital === company?.capital) {
        params.capital = undefined
      }
      if (params.totalEmployee === company?.totalEmployee) {
        params.totalEmployee = undefined
      }
      if (params.foundingDate === company?.foundingDate) {
        params.foundingDate = undefined
      }
      if (params.annualSales === company?.annualSales) {
        params.annualSales = undefined
      }
      return params
    }

    onMounted(() => {
      load(loading, async () => {
        await optionsModule.getBusinessCategories()
        await optionsModule.getPrefectures()
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
        subsidiesModule.setSearchParams(state)
        const pageQuery = route.value.query.page?.toString() || null
        const page = pageQuery ? Number(pageQuery) : 1
        subsidiesModule.getSubsidies(page)
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
      businessCategoryKeys,
      cities,
      state,
      search,
      capitalMan,
      capitalChanged,
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

.input-left {
  width: 80%;
}

.unit-font {
  font-size: 14px;
}
</style>
