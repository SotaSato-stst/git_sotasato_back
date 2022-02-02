<template>
  <div class="container">
    <div class="search-title">補助金情報検索</div>
    <el-form class="form" :model="state" label-width="120px">
      <div class="search-item">
        <div class="search-label">都道府県</div>
        <el-select
          v-model="state.prefectureId"
          placeholder="都道府県"
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
          v-model="state.cityIds"
          multiple
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
  reactive,
} from '@nuxtjs/composition-api'
import {Form, FormItem, Input, Button} from 'element-ui'
import {optionsModule, subsidiesModule} from '@/store'
import {useLoader} from '@/services/useLoader'

export default defineComponent({
  name: 'GlobalSideMenu',
  components: {
    [`${Form.name}`]: Form,
    [`${FormItem.name}`]: FormItem,
    [`${Input.name}`]: Input,
    [`${Button.name}`]: Button,
  },
  layout: 'admin',
  setup(_props) {
    const {loading, load} = useLoader()
    const prefectures = computed(() => optionsModule.prefectures)
    const selectPrefectureId = async (prefectureId: number) => {
      await optionsModule.getCities(prefectureId)
    }
    const cities = computed(() => optionsModule.cities)
    const state = reactive({
      prefectureId: '',
      cityIds: [],
    })

    const submit = () => {
      subsidiesModule.setSearchParams({
        prefectureIds: state.prefectureId,
        cityIds: state.cityIds.join('|'),
      })
      load(loading, async () => {
        await subsidiesModule.getSubsidies()
      })
    }

    onMounted(() => {
      load(loading, async () => {
        await optionsModule.getPrefectures()
      })
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
