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
        ref="form"
        :subsidy-params="subsidyParams"
        :loader="loader"
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
import {Card, Tag} from 'element-ui'
import {adminSubsidiesModule} from '@/store'
import {
  notifyError,
  notifySuccess,
  showApiErrorMessage,
} from '@/services/notify'
import {PublishingCode, UpdateSubsidyParams} from '@/types/Subsidy'
import {ValidationForm} from '@/types/Validate'
import SubsidyForm from '@/components/subsidies/SubsidyForm.vue'
import {routingService} from '@/services/routingService'
import {publishingCodeLabel} from '@/utils/enumKeyToName'
import {removeEmpty} from '@/utils/objectUtil'

export default defineComponent({
  name: 'AdminSubsidyDetail',
  components: {
    [`${Card.name}`]: Card,
    [`${Tag.name}`]: Tag,
    SubsidyForm,
  },
  layout: 'admin',
  setup(_props) {
    const form = ref<ValidationForm | null>(null)
    const router = useRouter()
    const loader = adminSubsidiesModule.loader
    const {loading, load} = loader
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
          load(loading, async () => {
            await adminSubsidiesModule
              .postSubsidy(removeEmpty(subsidyParams))
              .then(showMessage)
              .catch(showApiErrorMessage)
          })
        })
      })
    }

    const showMessage = (subsidyId: number) => {
      switch (subsidyParams.publishingCode) {
        case 'editing':
          notifySuccess('非公開で保存しました', `${subsidyParams.title}`)
          break
        case 'published':
          notifySuccess(
            '情報を公開しました',
            `${subsidyParams.title}
            <br/><a href="
            ${routingService.SubsidyDetail(subsidyId)}
            " target="_blank">公開ページを確認する</a>`,
          )
          break
      }
      router.replace(routingService.AdminSubsidyDetail(subsidyId))
    }

    onUnmounted(() => {
      adminSubsidiesModule.setSubsidy(null)
    })

    return {
      form,
      loader,
      loading,
      subsidyParams,
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
