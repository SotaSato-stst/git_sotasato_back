<template>
  <div class="container">
    <el-card>
      <div slot="header" class="form-header">
        <p>新規給付金情報の追加</p>
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
        v-if="!loading"
        ref="form"
        :benefit-params="benefitParams"
        :loading="loading"
      />
    </el-card>
  </div>
</template>

<script lang="ts">
import {
  defineComponent,
  onUnmounted,
  useRouter,
  useRoute,
  reactive,
  ref,
  onMounted,
} from '@nuxtjs/composition-api'
import {adminBenefitsModule, subsidyDraftsModule} from '@/store'
import {
  notifyError,
  notifySuccess,
  showApiErrorMessage,
} from '@/services/notify'
import {PublishingCode, UpdateBenefitParams} from '@/types/Benefit'
import {ValidationForm} from '@/types/Validate'
import BenefitForm from '@/components/benefits/BenefitForm.vue'
import {routingService} from '@/services/routingService'
import {publishingCodeLabel} from '@/utils/enumKeyToName'
import {removeEmpty} from '@/utils/objectUtil'

export default defineComponent({
  name: 'AdminBenefitDetail',
  components: {
    BenefitForm,
  },
  layout: 'admin',
  setup(_props) {
    const form = ref<ValidationForm | null>(null)
    const router = useRouter()
    const route = useRoute()
    const loader = adminBenefitsModule.loader
    const {loading, load} = loader
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
            .postBenefit(removeEmpty(benefitParams))
            .then(showMessage)
            .catch(showApiErrorMessage)
        })
      })
    }

    const showMessage = (benefitId: number) => {
      switch (benefitParams.publishingCode) {
        case 'editing':
          notifySuccess('非公開で保存しました', `${benefitParams.title}`)
          break
        case 'published':
          notifySuccess('情報を公開しました', benefitParams.title)
          break
      }
      router.replace(routingService.AdminBenefitDetail(benefitId))
    }

    onMounted(() => {
      load(loading, async () => {
        const id = Number(route.value.query.subsidyDraftId)
        if (id < 1 || isNaN(id)) {
          return
        }
        await subsidyDraftsModule.getSubsidyDraft(id)
        const subsidyDraft = subsidyDraftsModule.subsidyDraft
        if (!subsidyDraft) {
          return
        }
        Object.assign(benefitParams, {
          title: subsidyDraft.title,
          url: subsidyDraft.url,
          prefectureId: subsidyDraft.prefecture?.id,
          cityId: subsidyDraft.city?.id,
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
      benefitParams,
      submit,
      publishingCodeLabel,
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
</style>
