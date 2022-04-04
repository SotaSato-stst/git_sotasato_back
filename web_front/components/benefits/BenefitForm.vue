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
    <el-form-item label="タイトル" prop="title">
      <el-input v-model="state.title" class="input-text" :disabled="loading" />
    </el-form-item>
    <div class="inline">
      <el-form-item label="都道府県" prop="prefectureId">
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
      <el-form-item label="市長区村" prop="cityId">
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
    <el-form-item label="締切日" prop="endDate">
      <el-date-picker
        v-model="endDate"
        type="date"
        placeholder="選択"
        class="input-range"
        :disabled="loading"
        @change="endDateChanged()"
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
    <el-form-item label="支給内容" prop="priceDetail">
      <el-input
        v-model="state.priceDetail"
        type="textarea"
        :autosize="{minRows: 4}"
        class="input-text"
        placeholder="金額、支給タイミング、回数/頻度など"
        :disabled="loading"
      />
    </el-form-item>
    <el-form-item label="申請方法" prop="applicationDetail">
      <el-input
        v-model="state.applicationDetail"
        type="textarea"
        :autosize="{minRows: 4}"
        class="input-text"
        placeholder="申請書類、申請先の情報など"
        :disabled="loading"
      />
    </el-form-item>
    <el-form-item label="支給となる対象年齢">
      <div class="inline">
        <el-form-item prop="ageFrom">
          <el-input
            v-model="state.ageFrom"
            class="input-number"
            type="number"
            :disabled="loading"
          />
          歳
        </el-form-item>
        <span class="range-between">~</span>
        <el-form-item prop="ageTo">
          <el-input
            v-model="state.ageTo"
            class="input-number"
            type="number"
            :disabled="loading"
          />
          歳
        </el-form-item>
      </div>
      <div class="sub-description">※以上、以下の場合は片方を空にする</div>
    </el-form-item>
    <el-form-item label="支給となる対象世帯年収">
      <div class="inline">
        <el-form-item prop="householdIncomeFrom">
          <el-input
            v-model="householdIncomeFromMan"
            class="input-number"
            type="number"
            :disabled="loading"
            @change="householdIncomeFromChanged()"
          />
          万円
        </el-form-item>
        <span class="range-between">~</span>
        <el-form-item prop="householdIncomeTo">
          <el-input
            v-model="householdIncomeToMan"
            class="input-number"
            type="number"
            :disabled="loading"
            @change="householdIncomeToChanged()"
          />
          万円
        </el-form-item>
      </div>
      <div class="sub-description">※以上、以下の場合は片方を空にする</div>
    </el-form-item>
    <el-form-item label="生活保護受給世帯が対象" prop="forWelfare">
      <el-checkbox v-model="state.forWelfare" :disabled="loading" />
    </el-form-item>
    <el-form-item label="介護が必要な世帯が対象" prop="forElderlyCare">
      <el-checkbox v-model="state.forElderlyCare" :disabled="loading" />
    </el-form-item>
    <el-form-item label="ひとり親世帯が対象" prop="forWidow">
      <el-checkbox v-model="state.forWidow" :disabled="loading" />
    </el-form-item>
    <el-form-item label="障がい者を含む世帯が対象" prop="forDisabled">
      <el-checkbox v-model="state.forDisabled" :disabled="loading" />
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
  watch,
  ref,
  PropType,
} from '@nuxtjs/composition-api'
import {Form} from 'element-ui'
import {optionsModule, adminBenefitsModule} from '@/store'
import {UpdateBenefitParams} from '@/types/Benefit'
import IconExternal from '@/components/icons/IconExternal.vue'

export default defineComponent({
  name: 'BenefitForm',
  components: {
    IconExternal,
  },
  layout: 'admin',
  props: {
    benefitParams: {
      type: Object as PropType<UpdateBenefitParams>,
      required: true,
    },
    submited: {
      type: Boolean as PropType<boolean>,
      required: true,
    },
  },
  setup(props, context) {
    const form = ref<Form | null>(null)
    const {load, loading} = adminBenefitsModule.loader
    const state: UpdateBenefitParams = reactive(props.benefitParams)
    const ministries = computed(() => optionsModule.ministries)
    const prefectures = computed(() => optionsModule.prefectures)
    const cities = computed(() => optionsModule.cities)
    const selectPrefectureId = (prefectureId: number | null) => {
      if (prefectureId) {
        state.cityId = null
        optionsModule.getCities(prefectureId)
      } else {
        state.prefectureId = null
      }
    }

    const householdIncomeFromMan = ref<number | null>(null)
    const householdIncomeFromChanged = () => {
      if (householdIncomeFromMan.value) {
        state.householdIncomeFrom = householdIncomeFromMan.value * 10000
      } else {
        state.householdIncomeFrom = null
      }
    }
    const householdIncomeToMan = ref<number | null>(null)
    const householdIncomeToChanged = () => {
      if (householdIncomeToMan.value) {
        state.householdIncomeTo = householdIncomeToMan.value * 10000
      } else {
        state.householdIncomeTo = null
      }
    }

    const endDate = ref<Date | null>(null)
    const endDateChanged = () => {
      state.endDate = endDate.value?.toLocaleDateString() || null
    }

    const rules = {
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
      targetDetail: [
        {
          required: true,
          message: '対象条件は必須です',
          trigger: 'change',
        },
      ],
      priceDetail: [
        {
          required: true,
          message: '支給内容は必須です',
          trigger: 'change',
        },
      ],
      applicationDetail: [
        {
          required: true,
          message: '申請方法は必須です',
          trigger: 'change',
        },
      ],
    }

    watch(
      () => props.submited,
      (submited, prev) => {
        if (submited && !prev) {
          load(loading, async () => {
            await form.value
              ?.validate()
              .then(() => context.emit('validHandler'))
              .catch(() => context.emit('invalidHandler'))
          })
        }
      },
    )

    watch(
      () => props.benefitParams.prefectureId,
      (prefectureId, prev) => {
        if (prefectureId && !prev) {
          optionsModule.getCities(prefectureId)
        }
      },
    )

    onMounted(() => {
      optionsModule.getPrefectures()
      householdIncomeFromMan.value = state.householdIncomeFrom
        ? state.householdIncomeFrom / 10000
        : null
      householdIncomeToMan.value = state.householdIncomeTo
        ? state.householdIncomeTo / 10000
        : null
      endDate.value = state.endDate ? new Date(state.endDate) : null
    })

    onUnmounted(() => {
      optionsModule.setCities([])
    })

    return {
      form,
      loading,
      state,
      ministries,
      prefectures,
      cities,
      selectPrefectureId,
      householdIncomeFromMan,
      householdIncomeFromChanged,
      householdIncomeToMan,
      householdIncomeToChanged,
      endDate,
      endDateChanged,
      rules,
    }
  },
})
</script>

<style lang="postcss" scoped>
.inline {
  display: flex;
  flex-wrap: wrap;
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

.sub-description {
  color: var(--text-font-color);
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
  color: var(--text-font-color);
}
</style>
