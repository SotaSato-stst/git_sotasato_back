<template>
  <div class="container">
    <el-card v-if="subsidyDraft">
      <el-alert v-if="subsidyDraft.archived" type="error">
        アーカイブされています
      </el-alert>
      <div slot="header" class="form-header">
        <p>新着補助金情報の編集・公開</p>
        <div class="button-group">
          <el-button
            class="submit-button"
            size="small"
            :disabled="subsidyDraft.archived || loading"
            @click="submit('editing')"
          >
            下書き保存
          </el-button>
          <el-button
            v-if="!subsidyCreated"
            type="success"
            class="submit-button"
            size="small"
            :disabled="subsidyDraft.archived || loading"
            @click="submit('published')"
          >
            保存して公開
          </el-button>
          <el-button
            v-if="subsidyCreated"
            type="success"
            class="submit-button"
            size="small"
            @click="segueSubsidyDetail(subsidyDraft.subsidyId)"
          >
            作成した情報を確認する
          </el-button>
          <el-button
            type="danger"
            class="submit-button"
            size="small"
            :disabled="loading"
            @click="toggleArchive(!subsidyDraft.archived)"
          >
            <div v-if="!subsidyDraft.archived">アーカイブ</div>
            <div v-if="subsidyDraft.archived">アーカイブを戻す</div>
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
  computed,
  defineComponent,
  onMounted,
  onUnmounted,
  useRoute,
  useRouter,
  reactive,
  ref,
} from '@nuxtjs/composition-api'
import {MessageBox} from 'element-ui'
import {subsidyDraftsModule, adminSubsidiesModule} from '@/store'
import {
  notifyError,
  notifySuccess,
  showApiErrorMessage,
} from '@/services/notify'
import {PublishingCode, UpdateSubsidyParams} from '@/types/Subsidy'
import SubsidyForm from '@/components/subsidies/SubsidyForm.vue'
import {routingService} from '@/services/routingService'

export default defineComponent({
  name: 'SubsidyDraftPage',
  components: {
    SubsidyForm,
  },
  layout: 'admin',
  setup(_props) {
    const route = useRoute()
    const router = useRouter()
    const {loading, load} = adminSubsidiesModule.loader
    const id = Number(route.value.params.id)
    const subsidyDraft = computed(() => subsidyDraftsModule.subsidyDraft)
    const subsidyCreated = computed(
      () => !!subsidyDraftsModule.subsidyDraft?.subsidyId,
    )
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
          .postSubsidy(subsidyParams)
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
          notifySuccess(
            '下書き保存しました',
            `${subsidyDraftsModule.subsidyDraft?.title}`,
          )
          break
        case 'published':
          notifySuccess('情報を公開しました', subsidyParams.title)
          break
      }
      router.replace(routingService.AdminSubsidyDetail(subsidyId))
    }

    const toggleArchive = (archive: boolean) => {
      const target = archive ? 'アーカイブ' : 'アーカイブを戻'
      MessageBox.confirm(subsidyParams.title, `この情報を${target}しますか？`)
        .then(() => {
          subsidyDraftsModule
            .updateSubsidyDraft({id, archive})
            .then(handleSuccess)
            .catch(showApiErrorMessage)
        })
        .catch(_ => {})
    }

    const handleSuccess = () => {
      notifySuccess(
        '更新しました',
        `${subsidyDraftsModule.subsidyDraft?.title}`,
      )
      subsidyDraftsModule.getSubsidyDraft(id)
    }

    const segueSubsidyDetail = (subsidyId: number) => {
      router.push(routingService.AdminSubsidyDetail(subsidyId))
    }

    onMounted(() => {
      load(loading, async () => {
        await subsidyDraftsModule
          .getSubsidyDraft(id)
          .catch(_ => router.push(routingService.AdminTop()))
        const subsidyDraft = subsidyDraftsModule.subsidyDraft
        if (!subsidyDraft) {
          return
        }
        Object.assign(subsidyParams, {
          title: subsidyDraft.title,
          url: subsidyDraft.url,
          ministryId: subsidyDraft.ministry?.id,
          prefectureId: subsidyDraft.prefecture?.id,
          cityId: subsidyDraft.city?.id,
          supplierType: subsidyDraft.supplierType,
        })
      })
    })

    onUnmounted(() => {
      subsidyDraftsModule.setSubsidyDraft(null)
    })

    return {
      loading,
      subsidyDraft,
      subsidyParams,
      submit,
      submited,
      validHandler,
      invalidHandler,
      toggleArchive,
      segueSubsidyDetail,
      subsidyCreated,
    }
  },
  head(): object {
    return {
      title: '新着補助金情報の編集・公開',
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

.button-group {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.submit-button {
  height: fit-content;
}
</style>
