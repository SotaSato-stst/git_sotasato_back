<template>
  <div class="container" :loading="loading">
    <el-card v-if="subsidyDraft">
      <div slot="header" class="form-header">
        <p>新着補助金情報の編集・公開</p>
        <div class="button-group">
          <el-button
            class="submit-button"
            size="small"
            @click="save('下書き保存', 'editing')"
          >
            下書き保存
          </el-button>
          <el-button class="submit-button" size="small" @click="saveAsPersonal">
            個人向けの情報として保存
          </el-button>
          <el-button
            type="success"
            class="submit-button"
            size="small"
            @click="save('保存して公開', 'published')"
          >
            保存して公開
          </el-button>
          <el-button
            type="danger"
            class="submit-button"
            size="small"
            @click="destroy"
          >
            削除
          </el-button>
        </div>
      </div>
      <subsidy-form ref="form" :subsidy-params="subsidyParams" />
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
import {Card} from 'element-ui'
import {subsidyDraftModule} from '@/store'
import {useLoader} from '@/services/useLoader'
import {notifyError, notifySuccess} from '@/services/notify'
import {PublishingCode, UpdateSubsidyParams} from '@/types/Subsidy'
import {ValidationForm} from '@/types/Validate'
import SubsidyForm from '@/components/subsidies/SubsidyForm.vue'
import {routingService} from '@/services/routingService'

export default defineComponent({
  name: 'SubsidyDraftPage',
  components: {
    [`${Card.name}`]: Card,
    SubsidyForm,
  },
  layout: 'admin',
  setup(_props) {
    const form = ref<ValidationForm | null>(null)
    const route = useRoute()
    const router = useRouter()
    const {loading, load} = useLoader()
    const pageId = Number(route.value.params.id)
    const subsidyDraft = computed(() => subsidyDraftModule.subsidyDraft)
    const subsidyParams: UpdateSubsidyParams = reactive({
      title: '',
      url: '',
      publishingCode: 'editing',
      subsidyCategory: 'hojo',
      startFrom: '',
      endTo: null,
      priceMax: 0,
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
    })

    const save = (publishingCode: PublishingCode) => {
      subsidyParams.publishingCode = publishingCode
      form.value?.validate(valid => {
        if (!valid) {
          notifyError('更新に失敗しました', '入力項目を確認してください')
          return
        }
        load(loading, async () => {
          await subsidyDraftModule
            .postSubsidy(subsidyParams)
            .then(id => {
              switch (publishingCode) {
                case 'editing':
                  postedEditing()
                  break
                case 'published':
                  postedPublished(id)
                  break
              }
            })
            .catch(error =>
              notifyError(
                '更新に失敗しました',
                error.response?.data?.errors?.join('<br/>') || error.message,
              ),
            )
        })
      })
    }

    const postedEditing = () => {
      notifySuccess(
        '下書き保存しました',
        `${subsidyDraftModule.subsidyDraft?.title}`,
      )
    }

    const postedPublished = (subsidyId: number) => {
      notifySuccess(
        '情報を公開しました',
        `${subsidyDraftModule.subsidyDraft?.title}
        <br/><a href="
        ${routingService.SubsidyDetail(subsidyId)}
        ">公開ページ</a>`,
      )
    }

    const saveAsPersonal = () => {
      console.log('saveAsPersonal')
    }

    const destroy = async () => {
      await subsidyDraftModule
        .deleteSubsidyDraft(pageId)
        .then(() => {
          notifySuccess(
            '削除しました',
            `${subsidyDraftModule.subsidyDraft?.title}`,
          )
          router.push(routingService.AdminTop())
        })
        .catch(error =>
          notifyError('削除に失敗しました', error.response.data.message),
        )
    }

    onMounted(() => {
      load(loading, async () => {
        await subsidyDraftModule.getSubsidyDraft(pageId)
        const subsidyDraft = subsidyDraftModule.subsidyDraft
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
      subsidyDraftModule.setSubsidyDraft(null)
    })

    return {
      form,
      loading,
      subsidyDraft,
      subsidyParams,
      save,
      saveAsPersonal,
      destroy,
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
