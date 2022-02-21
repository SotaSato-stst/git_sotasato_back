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
            type="success"
            class="submit-button"
            size="small"
            :disabled="subsidyDraft.archived || loading"
            @click="submit('published')"
          >
            保存して公開
          </el-button>
          <el-button
            type="danger"
            class="submit-button"
            size="small"
            :disabled="subsidyDraft.archived || loading"
            @click="archive"
          >
            アーカイブ
          </el-button>
        </div>
      </div>
      <subsidy-form
        ref="form"
        :subsidy-params="subsidyParams"
        :loader="loader"
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
import {Card, Alert, MessageBox} from 'element-ui'
import {subsidyDraftsModule} from '@/store'
import {
  notifyError,
  notifySuccess,
  showApiErrorMessage,
} from '@/services/notify'
import {PublishingCode, UpdateSubsidyParams} from '@/types/Subsidy'
import {ValidationForm} from '@/types/Validate'
import SubsidyForm from '@/components/subsidies/SubsidyForm.vue'
import {routingService} from '@/services/routingService'

export default defineComponent({
  name: 'SubsidyDraftPage',
  components: {
    [`${Card.name}`]: Card,
    [`${Alert.name}`]: Alert,
    SubsidyForm,
  },
  layout: 'admin',
  setup(_props) {
    const form = ref<ValidationForm | null>(null)
    const route = useRoute()
    const router = useRouter()
    const loader = subsidyDraftsModule.loader
    const {loading, load} = loader
    const pageId = Number(route.value.params.id)
    const subsidyDraft = computed(() => subsidyDraftsModule.subsidyDraft)
    const subsidyParams: UpdateSubsidyParams = reactive({
      title: '',
      url: '',
      publishingCode: 'editing',
      subsidyCategory: 'hojo',
      startFrom: null,
      endTo: null,
      priceMax: 10000,
      supportRatioMin: '',
      supportRatioMax: '',
      level: null,
      detail: '',
      targetDetail: '',
      ministryId: null,
      prefectureId: null,
      cityId: null,
      supplierType: 'ministry',
      businessCategories: [],
      keywords: '',
      rankingScore: null,
    })

    const submit = (publishingCode: PublishingCode) => {
      subsidyParams.publishingCode = publishingCode
      load(loading, () => {
        form.value?.validate(valid => {
          if (!valid) {
            notifyError('更新に失敗しました', '入力項目を確認してください')
            return
          }
          subsidyDraftsModule
            .postSubsidy(subsidyParams)
            .then(showMessage)
            .catch(showApiErrorMessage)
        })
      })
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
          notifySuccess(
            '情報を公開しました',
            `${subsidyDraftsModule.subsidyDraft?.title}
            <br/><a href="
            ${routingService.SubsidyDetail(subsidyId)}
            " target="_blank">公開ページを確認する</a>`,
          )
          break
      }
      router.replace(routingService.AdminSubsidyDetail(subsidyId))
    }

    const archive = () => {
      MessageBox.confirm(subsidyParams.title, 'この情報をアーカイブしますか？')
        .then(() => {
          subsidyDraftsModule
            .deleteSubsidyDraft(pageId)
            .then(() => {
              notifySuccess(
                'アーカイブしました',
                `${subsidyDraftsModule.subsidyDraft?.title}`,
              )
              router.push(routingService.AdminTop())
            })
            .catch(error =>
              notifyError(
                'アーカイブに失敗しました',
                error.response.data.message,
              ),
            )
        })
        .catch(_ => {})
    }

    onMounted(() => {
      load(loading, async () => {
        await subsidyDraftsModule
          .getSubsidyDraft(pageId)
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
      form,
      loader,
      loading,
      subsidyDraft,
      subsidyParams,
      submit,
      archive,
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
