<template>
  <div class="container">
    <el-card v-if="subsidy">
      <div slot="header" class="form-header">
        <div class="inline">
          <el-tag
            :type="subsidy.publishingCode == 'published' ? 'success' : 'info'"
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
            @click="preview(subsidy.id)"
          >
            掲載中のページを確認
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
    const route = useRoute()
    const router = useRouter()
    const loader = adminSubsidiesModule.loader
    const {loading, load} = loader
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
      targetDetail: '',
      ministryId: null,
      prefectureId: null,
      cityId: null,
      supplierType: 'ministry',
      businessCategories: [],
      rankingScore: 0,
    })

    const submit = (publishingCode: PublishingCode) => {
      subsidyParams.publishingCode = publishingCode
      load(loading, () => {
        form.value?.validate(valid => {
          if (!valid) {
            notifyError('更新に失敗しました', '入力項目を確認してください')
            return
          }
          adminSubsidiesModule
            .putSubsidy(subsidyParams)
            .then(showMessage)
            .catch(showApiErrorMessage)
        })
      })
    }

    const showMessage = (subsidyId: number) => {
      switch (subsidyParams.publishingCode) {
        case 'editing':
          notifySuccess(
            '非公開で保存しました',
            `${adminSubsidiesModule.subsidy?.title}`,
          )
          break
        case 'published':
          notifySuccess(
            '情報を公開しました',
            `${adminSubsidiesModule.subsidy?.title}
            <br/><a href="
            ${routingService.SubsidyDetail(subsidyId)}
            " target="_blank">公開ページを確認する</a>`,
          )
          break
      }
      adminSubsidiesModule.getSubsidy(pageId)
    }

    const preview = (subsidyId: number) => {
      router.push(routingService.SubsidyDetail(subsidyId))
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
          businessCategories: subsidy.businessCategories.map(b => b.key),
        })
      })
    })

    onUnmounted(() => {
      adminSubsidiesModule.setSubsidy(null)
    })

    return {
      form,
      loader,
      loading,
      subsidy,
      subsidyParams,
      submit,
      preview,
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
