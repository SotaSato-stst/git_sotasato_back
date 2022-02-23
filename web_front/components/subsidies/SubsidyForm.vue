<template>
  <el-form
    ref="form"
    class="form"
    :model="state"
    label-width="180px"
    :rules="rules"
  >
    <el-form-item label="参照元URL" prop="url">
      <el-input v-model="state.url" class="input-text" :disabled="loading" />
      <a :href="state.url" target="_blank" class="external-link">
        <span>{{ state.url }}</span>
        <icon-external :size="16" />
      </a>
    </el-form-item>
    <el-form-item label="種類" prop="subsidyCategory">
      <el-radio-group v-model="state.subsidyCategory" size="medium">
        <el-radio-button label="hojo">補助金</el-radio-button>
        <el-radio-button label="josei">助成金</el-radio-button>
        <el-radio-button label="kyufu">給付金</el-radio-button>
      </el-radio-group>
    </el-form-item>
    <el-form-item label="タイトル" prop="title">
      <el-input v-model="state.title" class="input-text" :disabled="loading" />
    </el-form-item>
    <div class="inline">
      <el-form-item label="発行機関" prop="supplierType">
        <el-select
          v-model="state.supplierType"
          placeholder="選択"
          class="select-input"
          :disabled="loading"
        >
          <el-option key="ministry" label="省庁" value="ministry" />
          <el-option key="prefecture" label="都道府県" value="prefecture" />
          <el-option key="city" label="市長区村" value="city" />
        </el-select>
      </el-form-item>
      <el-form-item
        v-if="state.supplierType == 'ministry'"
        label="省庁"
        prop="ministryId"
      >
        <el-select
          v-model="state.ministryId"
          placeholder="省庁"
          class="select-input"
          :disabled="loading"
        >
          <el-option
            v-for="ministry in ministries"
            :key="ministry.id"
            :label="ministry.name"
            :value="ministry.id"
          />
        </el-select>
      </el-form-item>
      <el-form-item
        v-if="state.supplierType != 'ministry'"
        label="都道府県"
        prop="prefectureId"
      >
        <el-select
          v-model="state.prefectureId"
          placeholder="都道府県"
          class="select-input"
          :disabled="loading"
          @change="selectPrefectureId"
        >
          <el-option key="all" label="全域" :value="null" />
          <el-option
            v-for="prefecture in prefectures"
            :key="prefecture.id"
            :label="prefecture.name"
            :value="prefecture.id"
          />
        </el-select>
      </el-form-item>
      <el-form-item
        v-if="state.supplierType == 'city'"
        label="市長区村"
        prop="cityId"
      >
        <el-select
          v-model="state.cityId"
          placeholder="市長区村"
          class="select-input"
          :disabled="loading"
        >
          <el-option key="all" label="全域" :value="null" />
          <el-option
            v-for="city in cities"
            :key="city.id"
            :label="city.name"
            :value="city.id"
          />
        </el-select>
      </el-form-item>
    </div>
    <el-form-item label="募集期間" required>
      <div class="inline">
        <el-form-item prop="startFrom">
          <el-date-picker
            v-model="startFrom"
            type="date"
            placeholder="選択"
            class="input-range"
            :disabled="loading"
            @change="startFromChanged()"
          />
        </el-form-item>
        <span class="range-between">~</span>
        <el-form-item prop="endTo">
          <el-date-picker
            v-model="endTo"
            type="date"
            placeholder="選択"
            class="input-range"
            :disabled="loading"
            @change="endToChanged()"
          />
        </el-form-item>
      </div>
    </el-form-item>
    <el-form-item label="最大支援金額" prop="priceMax">
      <div class="inline">
        <el-input
          v-model="priceMaxMan"
          type="number"
          class="input-number input-number-text-align-center"
          :disabled="loading"
          @change="priceMaxChanged()"
        />
        万円
        <el-form-item label="支援割合" label-width="120px">
          <div class="inline">
            <el-form-item prop="supportRatioMin">
              <el-input
                v-model="state.supportRatioMin"
                placeholder="1/2, 30%など"
                class="input-range"
                :disabled="loading"
              />
            </el-form-item>
            <span class="range-between">~</span>
            <el-form-item prop="supportRatioMax">
              <el-input
                v-model="state.supportRatioMax"
                placeholder="2/3, 60%など"
                class="input-range"
                :disabled="loading"
              />
            </el-form-item>
          </div>
        </el-form-item>
      </div>
    </el-form-item>
    <el-form-item label="詳細" prop="detail">
      <el-input
        v-model="state.detail"
        type="textarea"
        class="input-text"
        :autosize="{minRows: 4}"
        placeholder="URLに記載されている内容"
        :disabled="loading"
      />
    </el-form-item>
    <el-form-item label="対象者の条件" prop="targetDetail">
      <el-input
        v-model="state.targetDetail"
        type="textarea"
        :autosize="{minRows: 4}"
        class="input-text"
        placeholder="受け取れることのできる条件"
        :disabled="loading"
      />
    </el-form-item>
    <el-form-item label="法人格" required>
      <div class="inline">
        <div class="two-column">
          <div>対象となる法人格</div>
          <el-select
            v-model="state.organizationTypes"
            multiple
            clearable
            class="organization-type-select"
            :disabled="loading"
            placeholder="対象となる法人格"
            prop="organizationTypes"
            @change="selectOrganizationTypes"
          >
            <el-option
              v-for="organizationType in organizationTypes"
              :key="organizationType.key"
              :label="organizationType.name"
              :value="organizationType.key"
            />
          </el-select>
        </div>
        <div class="two-column">
          <div>対象とならない法人格</div>
          <el-select
            v-model="noneOrganizationTypes"
            multiple
            clearable
            class="organization-type-select"
            :disabled="loading"
            placeholder="対象とならない法人格"
            @change="selectNoneOrganizationTypes"
          >
            <el-option
              v-for="organizationType in organizationTypes"
              :key="organizationType.key"
              :label="organizationType.name"
              :value="organizationType.key"
            />
          </el-select>
        </div>
      </div>
    </el-form-item>
    <el-form-item label="業種" prop="businessCategories">
      <el-select
        v-model="state.businessCategories"
        multiple
        placeholder="対応可能な業種"
        class="business-category-select"
        clearable
        :disabled="loading"
      >
        <el-option
          v-for="businessCategory in businessCategories"
          :key="businessCategory.key"
          :label="businessCategory.name"
          :value="businessCategory.key"
        />
      </el-select>
      <el-button class="select-all" @click="selectAllBusinessCategories">
        すべての業種を選択
      </el-button>
      <el-button class="select-all" @click="clearBusinessCategories">
        クリア
      </el-button>
    </el-form-item>
    <el-form-item label="対象となる従業員数">
      <div class="inline">
        <el-form-item prop="totalEmployeeMin">
          <el-input
            v-model="state.totalEmployeeMin"
            class="input-number"
            type="number"
            placeholder="100"
            :disabled="loading"
          />
          人
        </el-form-item>
        <span class="range-between">~</span>
        <el-form-item prop="totalEmployeeMax">
          <el-input
            v-model="state.totalEmployeeMax"
            class="input-number"
            type="number"
            placeholder="100"
            :disabled="loading"
          />
          人
        </el-form-item>
      </div>
      <div class="sub-description">※以上、以下の場合は片方を空にする</div>
    </el-form-item>
    <el-form-item label="対象となる資本金">
      <div class="inline">
        <el-form-item prop="capitalMin">
          <el-input
            v-model="capitalMinMan"
            class="input-number"
            type="number"
            placeholder="1000"
            :disabled="loading"
            @change="capitalMinChanged()"
          />
          万円
        </el-form-item>
        <span class="range-between">~</span>
        <el-form-item prop="capitalMax">
          <el-input
            v-model="capitalMaxMan"
            class="input-number"
            type="number"
            placeholder="1000000"
            :disabled="loading"
            @change="capitalMaxChanged()"
          />
          万円
        </el-form-item>
      </div>
      <div class="sub-description">※以上、以下の場合は片方を空にする</div>
    </el-form-item>
    <el-form-item label="対象となる年商(年間売上)">
      <div class="inline">
        <el-form-item prop="annualSalesMin">
          <el-input
            v-model="annualSalesMinMan"
            class="input-number"
            type="number"
            placeholder="1000"
            :disabled="loading"
            @change="annualSalesMinChanged()"
          />
          万円
        </el-form-item>
        <span class="range-between">~</span>
        <el-form-item prop="annualSalesMax">
          <el-input
            v-model="annualSalesMaxMan"
            class="input-number"
            type="number"
            placeholder="1000"
            :disabled="loading"
            @change="annualSalesMaxChanged()"
          />
          万円
        </el-form-item>
      </div>
      <div class="sub-description">※以上、以下の場合は片方を空にする</div>
    </el-form-item>
    <el-form-item label="対象となる会社設立年数" prop="yearsOfEstablishment">
      <el-input
        v-model="state.yearsOfEstablishment"
        class="input-number"
        type="number"
        placeholder="3"
        :disabled="loading"
      />
      年
    </el-form-item>
    <el-form-item label="申請難易度" prop="level">
      <el-rate
        v-model="level"
        :colors="['var(--text-color)']"
        :texts="['低い', 'やや低め', '普通', 'やや高め', '高い']"
        show-text
        class="level"
        :disabled="loading"
        @change="levelChanged()"
      />
    </el-form-item>
    <el-form-item label="ランキング点数" prop="rankingScore">
      <el-input
        v-model="state.rankingScore"
        type="number"
        class="input-number input-number-text-align-center"
        :disabled="loading"
      />
      点
    </el-form-item>
    <el-form-item label="検索キーワード" prop="keywords">
      <el-input
        v-model="state.keywords"
        type="textarea"
        class="input-text"
        placeholder="スペースまたは改行で単語ごとに登録"
        :autosize="{minRows: 2}"
        :disabled="loading"
      />
      <div>トップ検索ワード一覧</div>
      <div class="inline">
        <div v-for="keyword in topKeywords" :key="keyword">
          <el-button
            size="mini"
            class="keyword-button"
            @click="addKeyword(keyword)"
          >
            +{{ keyword }}
          </el-button>
        </div>
      </div>
    </el-form-item>
  </el-form>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  onMounted,
  onUnmounted,
  reactive,
  ref,
  PropType,
} from '@nuxtjs/composition-api'
import {
  Form,
  FormItem,
  Input,
  Button,
  RadioGroup,
  RadioButton,
  Rate,
} from 'element-ui'
import {optionsModule, keywordsModule} from '@/store'
import {UpdateSubsidyParams} from '@/types/Subsidy'
import {Validate} from '@/types/Validate'
import IconExternal from '@/components/icons/IconExternal.vue'

export default defineComponent({
  name: 'SubsidyForm',
  components: {
    [`${Form.name}`]: Form,
    [`${FormItem.name}`]: FormItem,
    [`${Input.name}`]: Input,
    [`${Button.name}`]: Button,
    [`${RadioGroup.name}`]: RadioGroup,
    [`${RadioButton.name}`]: RadioButton,
    [`${Rate.name}`]: Rate,
    IconExternal,
  },
  layout: 'admin',
  props: {
    subsidyParams: {
      type: Object as PropType<UpdateSubsidyParams>,
      required: true,
    },
    loading: {
      type: Boolean as PropType<boolean>,
      required: true,
    },
  },
  setup(props) {
    const form = ref<Form | null>(null)
    const state: UpdateSubsidyParams = reactive(props.subsidyParams)
    const ministries = computed(() => optionsModule.ministries)
    const prefectures = computed(() => optionsModule.prefectures)
    const cities = computed(() => optionsModule.cities)
    const selectPrefectureId = async (prefectureId: number | null) => {
      if (!prefectureId) {
        return
      }
      state.cityId = null
      await optionsModule.getCities(prefectureId)
    }

    const organizationTypes = computed(() => optionsModule.organizationTypes)
    const noneOrganizationTypes = ref<string[]>([])
    const selectOrganizationTypes = () => {
      noneOrganizationTypes.value = optionsModule.organizationTypes
        .map(o => o.key)
        .filter(key => !state.organizationTypes.includes(key))
    }
    const selectNoneOrganizationTypes = () => {
      state.organizationTypes = optionsModule.organizationTypes
        .map(o => o.key)
        .filter(key => !noneOrganizationTypes.value.includes(key))
    }
    const businessCategories = computed(() => optionsModule.businessCategories)
    const selectAllBusinessCategories = () => {
      state.businessCategories = optionsModule.businessCategories.map(
        b => b.key,
      )
    }
    const clearBusinessCategories = () => {
      state.businessCategories = []
    }

    const priceMaxMan = ref<number | null>(null)
    const priceMaxChanged = () => {
      if (priceMaxMan.value) {
        state.priceMax = priceMaxMan.value * 10000
      } else {
        state.priceMax = null
      }
    }

    const capitalMinMan = ref<number | null>(null)
    const capitalMinChanged = () => {
      if (capitalMinMan.value) {
        state.capitalMin = capitalMinMan.value * 10000
      } else {
        state.capitalMin = null
      }
    }
    const capitalMaxMan = ref<number | null>(null)
    const capitalMaxChanged = () => {
      if (capitalMaxMan.value) {
        state.capitalMax = capitalMaxMan.value * 10000
      } else {
        state.capitalMax = null
      }
    }

    const annualSalesMinMan = ref<number | null>(null)
    const annualSalesMinChanged = () => {
      if (annualSalesMinMan.value) {
        state.annualSalesMin = annualSalesMinMan.value * 10000
      } else {
        state.annualSalesMin = null
      }
    }
    const annualSalesMaxMan = ref<number | null>(null)
    const annualSalesMaxChanged = () => {
      if (annualSalesMaxMan.value) {
        state.annualSalesMax = annualSalesMaxMan.value * 10000
      } else {
        state.annualSalesMax = null
      }
    }

    const startFrom = ref<Date | null>(null)
    const startFromChanged = () => {
      state.startFrom = startFrom.value?.toLocaleDateString() || null
    }
    const endTo = ref<Date | null>(null)
    const endToChanged = () => {
      state.endTo = endTo.value?.toLocaleDateString() || null
    }
    const level = ref<number | null>(null)
    const levelChanged = () => {
      if (level.value === 0) {
        state.level = null
      } else {
        state.level = level.value
      }
    }

    const topKeywords = computed(() => keywordsModule.topKeywords)
    const addKeyword = (word: string) => {
      state.keywords = state.keywords + ' ' + word
    }

    const validate: Validate = (result: (valid: boolean) => void) => {
      form.value?.validate(valid => result(valid))
    }

    const rules = {
      subsidyCategory: [
        {
          required: true,
          message: '種類は必須です',
          trigger: 'change',
        },
      ],
      url: [
        {
          required: true,
          message: 'URLは必須です',
          trigger: 'change',
        },
      ],
      title: [
        {
          required: true,
          message: 'タイトルは必須です',
          trigger: 'change',
        },
      ],
      supplierType: [
        {
          required: true,
          message: '発行機関は必須です',
          trigger: 'change',
        },
      ],
      startFrom: [
        {
          required: true,
          message: '募集開始日は必須です',
          trigger: 'change',
        },
      ],
      targetDetail: [
        {
          required: true,
          message: '対象条件は必須です',
          trigger: 'change',
        },
      ],
      detail: [
        {
          required: true,
          message: '詳細は必須です',
          trigger: 'change',
        },
      ],
      organizationTypes: [
        {
          required: true,
          message: '詳細は必須です',
          trigger: 'change',
        },
      ],
    }

    onMounted(async () => {
      optionsModule.getMinistries()
      await optionsModule.getPrefectures()
      if (state.prefectureId) {
        await optionsModule.getCities(state.prefectureId)
      }
      await optionsModule.getOrganizationTypes()
      optionsModule.getBusinessCategories()
      keywordsModule.getTopKeywords()
      priceMaxMan.value = state.priceMax ? state.priceMax / 10000 : null
      capitalMinMan.value = state.capitalMin ? state.capitalMin / 10000 : null
      capitalMaxMan.value = state.capitalMax ? state.capitalMax / 10000 : null
      annualSalesMinMan.value = state.annualSalesMin
        ? state.annualSalesMin / 10000
        : null
      annualSalesMaxMan.value = state.annualSalesMax
        ? state.annualSalesMax / 10000
        : null
      startFrom.value = state.startFrom ? new Date(state.startFrom) : null
      endTo.value = state.endTo ? new Date(state.endTo) : null
      level.value = state.level
      if (state.organizationTypes.length === 0) {
        selectNoneOrganizationTypes()
      } else {
        selectOrganizationTypes()
      }
    })

    onUnmounted(() => {
      optionsModule.setCities([])
    })

    return {
      form,
      state,
      ministries,
      prefectures,
      cities,
      selectPrefectureId,
      organizationTypes,
      noneOrganizationTypes,
      selectOrganizationTypes,
      selectNoneOrganizationTypes,
      businessCategories,
      selectAllBusinessCategories,
      clearBusinessCategories,
      priceMaxMan,
      priceMaxChanged,
      capitalMinMan,
      capitalMinChanged,
      capitalMaxMan,
      capitalMaxChanged,
      annualSalesMinMan,
      annualSalesMinChanged,
      annualSalesMaxMan,
      annualSalesMaxChanged,
      startFrom,
      startFromChanged,
      endTo,
      endToChanged,
      level,
      levelChanged,
      topKeywords,
      addKeyword,
      validate,
      rules,
    }
  },
})
</script>

<style lang="postcss" scoped>
.inline {
  display: flex;
}

.select-input {
  width: 160px;
}

.input-text {
  width: 640px;
}

.input-range {
  width: 160px;
}

.range-between {
  margin: 0 var(--spacing-4);
}

.input-number {
  width: 160px;
}

.organization-type-select {
  width: 420px;
}

.business-category-select {
  width: 640px;
}

.select-all {
  border: none;
  color: var(--primary-color);
}

.two-column {
  width: 80%;
}

.external-link {
  display: flex;
  align-items: center;
  width: fit-content;
}

.level {
  height: 40px;
  display: flex;
  align-items: center;
}

.keyword-button {
  margin-right: var(--spacing-2);
}

.sub-description {
  color: var(--text-color);
  font-size: 12px;
  height: fit-content;
}
</style>

<style lang="postcss">
.input-number-text-align-center input {
  text-align: center;
}

.el-icon-star-on {
  font-size: 24px;
  color: var(--text-color);
}
</style>
