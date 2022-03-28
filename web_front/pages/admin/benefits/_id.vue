<template>
  <div class="container">
    <el-card v-if="benefit">
      <div slot="header" class="form-header">
        <div class="inline">
          <el-tag
            :type="publishingCodeType(benefit.publishingCode)"
            effect="dark"
          >
            {{ publishingCodeLabel(benefit.publishingCode) }}
          </el-tag>
          <p>「{{ benefit.title }}」の編集・公開</p>
        </div>
        <div class="button-group">
          <el-button
            class="submit-button"
            size="small"
            :disabled="loading"
            @click="submit('editing')"
          >
            非公開で保存
          </el-button>
          <el-button
            type="success"
            class="submit-button"
            size="small"
            :disabled="loading"
            @click="submit('published')"
          >
            保存して公開
          </el-button>
        </div>
      </div>
      <benefit-form
        ref="form"
        :benefit-params="benefitParams"
        :loading="loading"
      />
      <el-button
        type="danger"
        class="submit-button archive-button"
        size="small"
        :disabled="loading"
        @click="submit('archived')"
      >
        この情報をアーカイブする
      </el-button>
    </el-card>
  </div>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  onMounted,
  onUnmounted,
  useRoute,
  useRouter,
  reactive,
  ref,
} from '@nuxtjs/composition-api'
import {adminBenefitsModule} from '@/store'
import {
  notifyError,
  notifySuccess,
  showApiErrorMessage,
} from '@/services/notify'
import {PublishingCode, UpdateBenefitParams} from '@/types/Benefit'
import {ValidationForm} from '@/types/Validate'
import BenefitForm from '@/components/benefits/BenefitForm.vue'
import {routingService} from '@/services/routingService'
import {publishingCodeLabel, publishingCodeType} from '@/utils/enumKeyToName'

export default defineComponent({
  name: 'AdminBenefitDetail',
  components: {
    BenefitForm,
  },
  layout: 'admin',
  setup(_props) {
    const form = ref<ValidationForm | null>(null)
    const route = useRoute()
    const router = useRouter()
    const loader = adminBenefitsModule.loader
    const {loading, load} = loader
    const pageId = Number(route.value.params.id)
    const benefit = computed(() => adminBenefitsModule.benefit)
    const benefitParams: UpdateBenefitParams = reactive({
      title: '',
      url: '',
      endDate: null,
      publishingCode: 'editing',
      targetDetail: '',
      priceDetail: '',
      applicationDetail: '',
      prefectureId: null,
      cityId: null,
      forWelfare: false,
      forElderlyCare: false,
      forWidow: false,
      forDisabled: false,
      ageFrom: null,
      ageTo: null,
      householdIncomeFrom: null,
      householdIncomeTo: null,
    })

    const submit = (publishingCode: PublishingCode) => {
      benefitParams.publishingCode = publishingCode
      load(loading, () => {
        form.value?.validate(valid => {
          if (!valid) {
            notifyError('更新に失敗しました', '入力項目を確認してください')
            return
          }
          adminBenefitsModule
            .putBenefit(benefitParams)
            .then(showMessage)
            .catch(showApiErrorMessage)
        })
      })
    }

    const showMessage = (_: number) => {
      switch (benefitParams.publishingCode) {
        case 'editing':
          notifySuccess(
            '非公開で保存しました',
            `${adminBenefitsModule.benefit?.title}`,
          )
          break
        case 'published':
          notifySuccess('情報を公開しました', benefitParams.title)
          break
      }
      adminBenefitsModule.getBenefit(pageId)
    }

    const show = (benefitId: number) => {
      router.push(routingService.BenefitDetail(benefitId))
    }

    const preview = (benefitId: number) => {
      router.push({
        path: routingService.BenefitDetail(benefitId),
        query: {preview: 'true'},
      })
    }

    onMounted(() => {
      load(loading, async () => {
        await adminBenefitsModule
          .getBenefit(pageId)
          .catch(_ => router.push(routingService.AdminBenefits()))
        const benefit = adminBenefitsModule.benefit
        if (!benefit) {
          return
        }
        Object.assign(benefitParams, benefit)
        Object.assign(benefitParams, {
          prefectureId: benefit.prefecture?.id,
          cityId: benefit.city?.id,
        })
      })
    })

    onUnmounted(() => {
      adminBenefitsModule.setBenefit(null)
    })

    return {
      form,
      loader,
      loading,
      benefit,
      benefitParams,
      submit,
      show,
      preview,
      publishingCodeLabel,
      publishingCodeType,
    }
  },
  head(): object {
    return {
      title: '補助金情報の編集・公開',
    }
  },
})
</script>

<style lang="postcss" scoped>
.form-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.inline {
  display: flex;
  align-items: center;
}

.button-group {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.submit-button {
  height: fit-content;
}

.archive-button {
  margin-left: 180px;
}
</style>
