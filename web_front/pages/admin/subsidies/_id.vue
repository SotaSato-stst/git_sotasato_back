<template>
  <div class="container">
    <el-card v-if="subsidy">
      <div slot="header" class="form-header">
        <div class="inline">
          <el-tag
            :type="publishingCodeType(subsidy.publishingCode)"
            effect="dark"
          >
            {{ publishingCodeLabel(subsidy.publishingCode) }}
          </el-tag>
          <p>「{{ subsidy.title }}」の編集・公開</p>
        </div>
        <div class="button-group">
          <el-button
            v-if="subsidy.publishingCode == 'published'"
            class="submit-button"
            size="small"
            :disabled="loading"
            @click="show(subsidy.id)"
          >
            掲載中のページを確認
          </el-button>
          <el-button
            v-if="subsidy.publishingCode == 'editing'"
            class="submit-button"
            size="small"
            :disabled="loading"
            @click="preview(subsidy.id)"
          >
            プレビュー
          </el-button>
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
        :subsidy-params="subsidyParams"
        :submited="submited"
        @validHandler="validHandler"
        @invalidHandler="invalidHandler"
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
import {adminSubsidiesModule} from '@/store'
import {
  notifyError,
  notifySuccess,
  showApiErrorMessage,
} from '@/services/notify'
import {PublishingCode, UpdateSubsidyParams} from '@/types/Subsidy'
import SubsidyForm from '@/components/subsidies/SubsidyForm.vue'
import {routingService} from '@/services/routingService'
import {publishingCodeLabel, publishingCodeType} from '@/utils/enumKeyToName'

export default defineComponent({
  name: 'AdminSubsidyDetail',
  components: {
    SubsidyForm,
  },
  layout: ctx => (ctx.$device.isMobile ? 'admin-mobile' : 'admin'),
  setup(_props) {
    const route = useRoute()
    const router = useRouter()
    const {loading, load} = adminSubsidiesModule.loader
    const pageId = Number(route.value.params.id)
    const subsidy = computed(() => adminSubsidiesModule.subsidy)
    const subsidyParams: UpdateSubsidyParams = reactive({
      title: '',
      url: '',
      publishingCode: 'editing',
      subsidyCategory: 'hojo',
      startFrom: null,
      endTo: null,
      priceMax: 0,
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
      capitalMax: 0,
      capitalMin: 0,
      totalEmployeeMin: 0,
      totalEmployeeMax: 0,
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
          .putSubsidy(subsidyParams)
          .then(showMessage)
          .catch(showApiErrorMessage)
      })
      submited.value = false
    }

    const invalidHandler = () => {
      notifyError('更新に失敗しました', '入力内容を確認してください')
      submited.value = false
    }

    const showMessage = (_: number) => {
      switch (subsidyParams.publishingCode) {
        case 'editing':
          notifySuccess(
            '非公開で保存しました',
            `${adminSubsidiesModule.subsidy?.title}`,
          )
          break
        case 'published':
          notifySuccess('情報を公開しました', subsidyParams.title)
          break
        case 'archived':
          notifySuccess('アーカイブしました', subsidyParams.title)
          break
      }
      adminSubsidiesModule.getSubsidy(pageId)
    }

    const show = (subsidyId: number) => {
      router.push(routingService.SubsidyDetail(subsidyId))
    }

    const preview = (subsidyId: number) => {
      router.push({
        path: routingService.SubsidyDetail(subsidyId),
        query: {preview: 'true'},
      })
    }

    onMounted(() => {
      load(loading, async () => {
        await adminSubsidiesModule
          .getSubsidy(pageId)
          .catch(_ => router.push(routingService.AdminSubsidies()))
        const subsidy = adminSubsidiesModule.subsidy
        if (!subsidy) {
          return
        }
        Object.assign(subsidyParams, subsidy)
        Object.assign(subsidyParams, {
          ministryId: subsidy.ministry?.id,
          prefectureId: subsidy.prefecture?.id,
          cityId: subsidy.city?.id,
          organizationTypes: subsidy.organizationTypes.map(b => b.key),
          businessCategories: subsidy.businessCategories.map(b => b.key),
          keywords: subsidy.keywords.join(' '),
        })
      })
    })

    onUnmounted(() => {
      adminSubsidiesModule.setSubsidy(null)
    })

    return {
      loading,
      subsidy,
      subsidyParams,
      submit,
      submited,
      validHandler,
      invalidHandler,
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

@media screen and (max-width: 1200px) {
  .form-header,
  .inline {
    flex-direction: column;
    overflow: scroll;
  }
}
</style>
