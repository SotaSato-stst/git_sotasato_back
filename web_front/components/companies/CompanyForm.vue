<template>
  <el-card v-if="state">
    <div slot="header" class="form-header">
      <p>「{{ state.name }}」の会社情報</p>
      <el-button
        type="primary"
        class="submit-button"
        :disabled="loading"
        @click="submit"
      >
        保存する
      </el-button>
    </div>
    <el-form
      ref="form"
      class="form"
      :model="state"
      :rules="rules"
      label-width="120px"
      :loading="loading"
    >
      <el-form-item label="会社名" prop="name">
        <el-input
          v-model="state.name"
          class="input-text"
          placeholder="株式会社補助金ドック"
          :disabled="loading"
        />
      </el-form-item>
      <el-form-item label="都道府県" prop="prefectureId">
        <el-select
          v-model="state.prefectureId"
          placeholder="都道府県"
          :disabled="loading"
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
      <el-form-item label="市長区村" prop="cityId">
        <el-select
          v-model="state.cityId"
          placeholder="市長区村"
          :disabled="loading"
        >
          <el-option
            v-for="city in cities"
            :key="city.id"
            :label="city.name"
            :value="city.id"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="住所" prop="adress">
        <el-input
          v-model="state.adress"
          class="input-text"
          placeholder="東京都千代田区oo町oo丁目oo番oo号 補助金ビル2F"
          :disabled="loading"
        />
      </el-form-item>
      <el-form-item label="業種" prop="businessCategories">
        <el-select
          v-model="state.businessCategories"
          multiple
          placeholder="業種"
          :disabled="loading"
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
      <el-form-item label="資本金" prop="capital">
        <el-input
          v-model="state.capital"
          class="input-number"
          type="number"
          placeholder="10000000"
          :disabled="loading"
        />
        円
      </el-form-item>
      <el-form-item label="従業員数" prop="totalEmployee">
        <el-input
          v-model="state.totalEmployee"
          class="input-number"
          type="number"
          placeholder="100"
          :disabled="loading"
        />
        人
      </el-form-item>
    </el-form>
  </el-card>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  onMounted,
  onUpdated,
  onUnmounted,
  reactive,
  PropType,
  ref,
} from '@nuxtjs/composition-api'
import {Card, Form, FormItem, Input, Button} from 'element-ui'
import {optionsModule} from '@/store'
import {CompanyParams} from '@/types/Company'
import {notifyError} from '~/services/notify'

export default defineComponent({
  name: 'CompanyForm',
  components: {
    [`${Card.name}`]: Card,
    [`${Form.name}`]: Form,
    [`${FormItem.name}`]: FormItem,
    [`${Input.name}`]: Input,
    [`${Button.name}`]: Button,
  },
  layout: 'admin',
  props: {
    companyParams: {
      type: Object as PropType<CompanyParams>,
      required: true,
    },
  },
  setup(props, context) {
    const form = ref<Form | null>(null)
    const {loading, load} = optionsModule.loader
    const prefectures = computed(() => optionsModule.prefectures)
    const businessCategories = computed(() => optionsModule.businessCategories)
    const selectPrefectureId = async (prefectureId: number | null) => {
      if (!prefectureId) {
        return
      }
      state.cityId = null
      await optionsModule.getCities(prefectureId)
    }
    const cities = computed(() => optionsModule.cities)
    const state: CompanyParams = reactive(props.companyParams)

    const submit = () => {
      load(loading, () => {
        form.value
          ?.validate()
          .then(() => context.emit('submit'))
          .catch(() =>
            notifyError('更新に失敗しました', '入力内容を確認してください'),
          )
      })
    }

    const rules = {
      name: [
        {
          required: true,
          message: '会社名は必須です',
          trigger: 'change',
        },
      ],
      prefectureId: [
        {
          required: true,
          message: '都道府県は必須です',
          trigger: 'change',
        },
      ],
      cityId: [
        {
          required: true,
          message: '市長区村は必須です',
          trigger: 'change',
        },
      ],
      businessCategories: [
        {
          required: true,
          message: '業種は必須です',
          trigger: 'change',
        },
      ],
    }

    onMounted(() => {
      load(loading, () => {
        optionsModule.getBusinessCategories()
        optionsModule.getPrefectures()
      })
    })

    onUpdated(() => {
      if (state.prefectureId && optionsModule.cities.length === 0) {
        optionsModule.getCities(state.prefectureId)
      }
    })

    onUnmounted(() => {
      optionsModule.setCities([])
    })

    return {
      form,
      loading,
      prefectures,
      selectPrefectureId,
      cities,
      businessCategories,
      state,
      rules,
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
