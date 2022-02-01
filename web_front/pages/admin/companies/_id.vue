<template>
  <div class="container">
    <el-card v-if="company">
      <div slot="header" class="form-header">
        <p>「{{ company.name }}」の会社情報</p>
        <el-button type="primary" @click="submit">保存する</el-button>
      </div>
      <el-form class="form" :model="state" label-width="120px">
        <el-form-item label="会社名">
          <el-input
            v-model="state.name"
            class="input-text"
            placeholder="株式会社補助金ドック"
          />
        </el-form-item>
        <el-form-item label="都道府県">
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
        </el-form-item>
        <el-form-item label="市長区村">
          <el-select v-model="state.cityId" placeholder="市長区村">
            <el-option
              v-for="city in cities"
              :key="city.id"
              :label="city.name"
              :value="city.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="住所">
          <el-input
            v-model="state.adress"
            class="input-text"
            placeholder="東京都千代田区oo町oo丁目oo番oo号 補助金ビル2F"
          />
        </el-form-item>
        <el-form-item label="資本金">
          <el-input
            v-model="state.capital"
            class="input-number"
            type="number"
            placeholder="10000000"
          />
          円
        </el-form-item>
        <el-form-item label="従業員数">
          <el-input
            v-model="state.totalEmployee"
            class="input-number"
            type="number"
            placeholder="100"
          />
          人
        </el-form-item>
        <el-form-item label="業種">
          <el-select
            v-model="state.businessCategories"
            multiple
            placeholder="業種"
            class="category-select"
          >
            <el-option
              v-for="businessCategory in businessCategories"
              :key="businessCategory.key"
              :label="businessCategory.name"
              :value="businessCategory.key"
            />
          </el-select>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  onMounted,
  useRoute,
  reactive,
} from '@nuxtjs/composition-api'
import {Card, Form, FormItem, Input, Button} from 'element-ui'
import {companiesModule, optionsModule} from '@/store'
import {useLoader} from '@/services/useLoader'
import {CompanyParams} from '@/types/Company'
import {notifySuccess} from '@/services/notify'

export default defineComponent({
  name: 'IndexPage',
  components: {
    [`${Card.name}`]: Card,
    [`${Form.name}`]: Form,
    [`${FormItem.name}`]: FormItem,
    [`${Input.name}`]: Input,
    [`${Button.name}`]: Button,
  },
  layout: 'admin',
  setup(_props) {
    const route = useRoute()
    const {loading, load} = useLoader()
    const pageId = Number(route.value.params.id)
    const company = computed(() => companiesModule.company)
    const prefectures = computed(() => optionsModule.prefectures)
    const businessCategories = computed(() => optionsModule.businessCategories)
    const selectPrefectureId = (prefectureId: number) => {
      optionsModule.getCities(prefectureId)
    }
    const cities = computed(() => optionsModule.cities)
    const state: CompanyParams = reactive(companiesModule.companyParams)

    const submit = async () => {
      companiesModule.setCompanyParams(state)
      await companiesModule.putCompany(pageId)
      notifySuccess(
        '内容を保存しました',
        `${companiesModule.company?.name}の会社情報`,
      )
    }

    onMounted(() => {
      load(loading, async () => {
        await companiesModule.getCompany(pageId)
        Object.assign(state, companiesModule.companyParams)
        optionsModule.getPrefectures()
        optionsModule.getBusinessCategories()
        const prfecture = companiesModule.company?.prefecture
        if (prfecture) {
          selectPrefectureId(prfecture.id)
        }
      })
    })

    return {
      loading,
      company,
      prefectures,
      selectPrefectureId,
      cities,
      businessCategories,
      state,
      submit,
    }
  },
})
</script>

<style lang="postcss" scoped>
.form-header {
  display: flex;
  justify-content: space-between;
}

.input-text {
  width: 400px;
}

.input-number {
  width: 240px;
}

.category-select {
  width: 400px;
}
</style>
