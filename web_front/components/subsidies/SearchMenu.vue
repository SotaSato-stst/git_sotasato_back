<template>
  <div v-loading="loading" class="container">
    <div class="search-title">補助金情報検索</div>
    <el-form class="form" :model="state" label-width="120px">
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
          v-model="state.capitalMan"
          class="input-number input-left"
          type="number"
          placeholder="100,000"
          @change="capitalChanged()"
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
import {optionsModule, subsidiesModule} from '@/store'
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
  layout: 'admin',
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
    })
    const capitalMan = ref<number | null>(null)
    const capitalChanged = () => {
      if (capitalMan.value) {
        state.capital = capitalMan.value * 10000
      }
    }

    const setStateFromQuery = () => {
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
      const totalEmployee = query.totalEmployee
      const capital = query.capital
      Object.assign(state, {
        cityIds,
        prefectureId,
        inApplicationPeriod,
        businessCategoryKeys,
        totalEmployee,
        capital,
      })
    }

    const search = () => {
      subsidiesModule.setSearchParams(state)
      const query = removeEmpty(subsidiesModule.searchParams)
      if (query.inApplicationPeriod === true) {
        query.inApplicationPeriod = undefined
      }
      load(loading, () => {
        router.push({path: routingService.Top(), query})
        subsidiesModule.getSubsidies()
      })
    }

    onMounted(() => {
      load(loading, async () => {
        await optionsModule.getBusinessCategories()
        await optionsModule.getPrefectures()
        if (route.value.path === routingService.Top()) {
          setStateFromQuery()
          if (state.prefectureId) {
            optionsModule.getCities(state.prefectureId)
          }
          search()
        }
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
