<template>
  <div class="container">
    <el-card>
      <div slot="header" class="form-header">
        <p>新規補助金情報の追加</p>
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
      <subsidy-form
        v-if="!loading"
        :subsidy-params="subsidyParams"
        :submited="submited"
        @validHandler="validHandler"
        @invalidHandler="invalidHandler"
      />
    </el-card>
  </div>
</template>

<script lang="ts">
import {
  defineComponent,
  onUnmounted,
  useRouter,
  reactive,
  ref,
} from '@nuxtjs/composition-api'
import {adminSubsidiesModule} from '@/store'
import {
  notifyError,
  notifySuccess,
  showApiErrorMessage,
} from '@/services/notify'
import {PublishingCode, UpdateSubsidyParams} from '@/types/Subsidy'
import SubsidyForm from '@/components/subsidies/SubsidyForm.vue'
import {routingService} from '@/services/routingService'
import {publishingCodeLabel} from '@/utils/enumKeyToName'
import {removeEmpty} from '@/utils/objectUtil'

export default defineComponent({
  name: 'AdminSubsidyDetail',
  components: {
    SubsidyForm,
  },
  layout: 'admin',
  setup(_props) {
    const router = useRouter()
    const {loading, load} = adminSubsidiesModule.loader
    const subsidyParams: UpdateSubsidyParams = reactive({
      title: '',
      url: '',
      publishingCode: 'editing',
      subsidyCategory: 'hojo',
      startFrom: null,
      endTo: null,
      priceMax: null,
      supportRatioMin: '',
      supportRatioMax: '',
      level: null,
      detail: '',
      ministryId: null,
      prefectureId: null,
      cityId: null,
      supplierType: 'ministry',
      organizationTypes: [],
      businessCategories: [],
      rankingScore: null,
      capitalMax: null,
      capitalMin: null,
      totalEmployeeMin: null,
      totalEmployeeMax: null,
      keywords: '',
      yearsOfEstablishment: null,
      annualSalesMax: null,
      annualSalesMin: null,
      catchCopy: '',
    })
    const submited = ref(false)

    const submit = (publishingCode: PublishingCode) => {
      subsidyParams.publishingCode = publishingCode
      submited.value = true
    }

    const validHandler = () => {
      load(loading, () => {
        adminSubsidiesModule
          .postSubsidy(removeEmpty(subsidyParams))
          .then(showMessage)
          .catch(showApiErrorMessage)
      })
      submited.value = false
    }

    const invalidHandler = () => {
      notifyError('更新に失敗しました', '入力内容を確認してください')
      submited.value = false
    }

    const showMessage = (subsidyId: number) => {
      switch (subsidyParams.publishingCode) {
        case 'editing':
          notifySuccess('非公開で保存しました', `${subsidyParams.title}`)
          break
        case 'published':
          notifySuccess('情報を公開しました', subsidyParams.title)
          break
      }
      router.replace(routingService.AdminSubsidyDetail(subsidyId))
    }

    onUnmounted(() => {
      adminSubsidiesModule.setSubsidy(null)
    })

    return {
      loading,
      subsidyParams,
      submit,
      submited,
      validHandler,
      invalidHandler,
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
