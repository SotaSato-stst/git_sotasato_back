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
            :value="prefecture.id.toString()"
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
            :value="city.id.toString()"
          />
        </el-select>
      </div>
      <el-button class="search-button" type="primary" @click="submit">
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
  reactive,
  useRoute,
  useRouter,
} from '@nuxtjs/composition-api'
import {Form, FormItem, Input, Button} from 'element-ui'
import {optionsModule, subsidiesModule} from '@/store'

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
    const router = useRouter()
    const {loading, load} = subsidiesModule.loader
    const prefectures = computed(() => optionsModule.prefectures)
    const selectPrefectureId = async (prefectureId: string) => {
      if (prefectureId.length === 0) {
        return
      }
      state.cityIds = []
      await optionsModule.getCities(prefectureId)
    }
    const cities = computed(() => optionsModule.cities)
    const state = reactive({
      prefectureId: route.value.query.prefectureIds?.toString() || '',
      cityIds: route.value.query.cityIds?.toString().split('|') || [],
    })

    const setParams = () => {
      subsidiesModule.setSearchParams({
        prefectureIds: state.prefectureId,
        cityIds: state.cityIds.join('|'),
      })
    }

    const submit = () => {
      setParams()
      load(loading, async () => {
        await subsidiesModule.getSubsidies()
        router.push({query: subsidiesModule.searchParams})
      })
    }

    onMounted(() => {
      setParams()
      load(loading, async () => {
        subsidiesModule.getSubsidies()
        await optionsModule.getPrefectures()
        if (state.prefectureId.length > 0) {
          optionsModule.getCities(state.prefectureId)
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
      submit,
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
