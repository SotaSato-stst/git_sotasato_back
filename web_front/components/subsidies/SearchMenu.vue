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
} from '@nuxtjs/composition-api'
import {Form, FormItem, Input, Button} from 'element-ui'
import {optionsModule, subsidiesModule} from '@/store'
import {routingService} from '~/services/routingService'
import {SubsidySearchForm} from '@/types/Subsidy'

export default defineComponent({
  name: 'SearchMenu',
  components: {
    [`${Form.name}`]: Form,
    [`${FormItem.name}`]: FormItem,
    [`${Input.name}`]: Input,
    [`${Button.name}`]: Button,
  },
  layout: 'admin',
  setup(_props) {
    const route = useRoute()
    const query = route.value.query
    const router = useRouter()
    const {loading, load} = subsidiesModule.loader
    const prefectures = computed(() => optionsModule.prefectures)
    const selectPrefectureId = (prefectureId: number | null) => {
      if (prefectureId) {
        optionsModule.getCities(prefectureId)
      }
    }
    const cities = computed(() => optionsModule.cities)

    const state: SubsidySearchForm = reactive({
      prefectureId: null,
      cityIds: [],
    })

    const setStateFromQuery = () => {
      const prefectureIdQuery = Number(query.prefectureId)
      const prefectureId =
        isNaN(prefectureIdQuery) || prefectureIdQuery === 0
          ? null
          : prefectureIdQuery
      const cityIds = query.cityIds?.toString().split('|').map(Number)
      Object.assign(state, {cityIds, prefectureId})
    }

    const search = () => {
      subsidiesModule.setSearchParams(state)
      load(loading, () => {
        router.push({
          path: routingService.Top(),
          query: subsidiesModule.searchParams,
        })
        subsidiesModule.getSubsidies()
      })
    }

    onMounted(() => {
      load(loading, async () => {
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
      cities,
      state,
      search,
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
</style>
