<template>
  <div v-if="subsidy" class="subsidy-detail-container">
    <div class="detail-header">
      <div class="header-title">詳細</div>
      <div class="button-group">
        <inquiry-button :subsidy="subsidy" />
        <favorite-button :subsidy="subsidy" />
      </div>
    </div>
    <el-card>
      <div class="card-content">
        <div class="title">{{ subsidy.title }}</div>
        <el-row>
          <el-col :span="12">
            <div class="subsidy-info">
              <span class="label">発行: </span>
              <span v-if="subsidy.ministry">{{ subsidy.ministry.name }}</span>
              <span v-if="subsidy.prefecture">
                {{ subsidy.prefecture.name }}
              </span>
              <span v-if="subsidy.city">{{ subsidy.city.name }}</span>
            </div>
          </el-col>
          <el-col :span="12">
            <div class="subsidy-info">
              <span class="label">種別: </span>
              <span v-if="subsidy.subsidyCategory">
                {{ subsidyCategoryLabel(subsidy.subsidyCategory) }}
              </span>
            </div>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <div class="subsidy-info">
              <span class="label">上限金額: </span>
              {{
                subsidy.priceMax ? convertToShortJPY(subsidy.priceMax) : '-'
              }}円
            </div>
          </el-col>
          <el-col
            v-if="subsidy.supportRatioMin || subsidy.supportRatioMax"
            :span="12"
          >
            <div class="subsidy-info">
              <span class="label">支援割合: </span>
              {{ subsidy.supportRatioMin }}
              ~
              {{ subsidy.supportRatioMax }}
            </div>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <div class="subsidy-info">
              <span class="label">募集期間: </span>
              <span v-if="subsidy.startFrom || subsidy.endTo">
                {{ convertDateRange(subsidy.startFrom, subsidy.endTo) }}
              </span>
              <span v-else>未定</span>
            </div>
          </el-col>
          <el-col v-if="subsidy.level" :span="12">
            <div class="subsidy-info">
              <span class="label">申請難易度: </span>
              {{ starView(subsidy.level) }}
            </div>
          </el-col>
        </el-row>
        <div class="subsidy-info">
          <span class="label">URL: </span>
          <a :href="subsidy.url" target="_blank">{{ subsidy.url }}</a>
        </div>
      </div>
      <div class="divider" />
      <div class="detail">
        <!-- eslint-disable vue/no-v-html -->
        <div
          class="subsidy-detail-markdown-content"
          v-html="parseMarkdown(subsidy.detail)"
        />
      </div>
    </el-card>
    <el-button
      v-if="isAdmin"
      size="mini"
      class="edit-admin"
      @click="showAdmin(subsidy.id)"
    >
      管理画面で編集する
    </el-button>
  </div>
</template>

<script lang="ts">
import {
  defineComponent,
  onMounted,
  onUnmounted,
  useRoute,
  useRouter,
  computed,
} from '@nuxtjs/composition-api'
import {getAnalytics, logEvent} from 'firebase/analytics'
import {marked} from 'marked'
import {subsidiesModule, accountModule} from '@/store'
import {convertDateRange} from '@/utils/dateFormatter'
import {convertToShortJPY} from '@/utils/numberFormatter'
import {starView} from '@/utils/starView'
import {subsidyCategoryLabel} from '@/utils/enumKeyToName'
import InquiryButton from '@/components/subsidies/InquiryButton.vue'
import FavoriteButton from '@/components/subsidies/FavoriteButton.vue'
import {routingService} from '~/services/routingService'

export default defineComponent({
  name: 'SubsidyDetailPage',
  components: {
    InquiryButton,
    FavoriteButton,
  },
  layout: ctx => (ctx.$device.isMobile ? 'mobile' : 'recent'),
  setup(_props) {
    const route = useRoute()
    const router = useRouter()
    const pageId = Number(route.value.params.id)
    const subsidy = computed(() => subsidiesModule.subsidy)
    const analytics = getAnalytics()
    const parseMarkdown = marked.parse
    const isAdmin = computed(() => accountModule.isAdmin)
    const isEditor = computed(() => accountModule.isEditor)
    const showAdmin = (subsidyId: number) => {
      router.push(routingService.AdminSubsidyDetail(subsidyId))
    }

    onMounted(async () => {
      if (route.value.query.preview === 'true') {
        await subsidiesModule.getSubsidyPreview(pageId)
      } else {
        await subsidiesModule.getSubsidy(pageId).catch(_ => router.push('/'))
      }
      if (subsidiesModule.subsidy) {
        subsidiesModule.addViewedSubsidies(subsidiesModule.subsidy)
        logEvent(analytics, 'subsidy_view', {
          content_type: 'subsidy',
          content_id: pageId,
          subsidy_title: subsidiesModule.subsidy.title,
        })
      }
    })

    onUnmounted(() => {
      subsidiesModule.setSubsidy(null)
    })

    return {
      convertToShortJPY,
      convertDateRange,
      starView,
      subsidyCategoryLabel,
      subsidy,
      parseMarkdown,
      isAdmin,
      isEditor,
      showAdmin,
    }
  },
  head(): object {
    return {
      title: this.subsidy?.title,
    }
  },
})
</script>

<style lang="postcss" scoped>
.subsidy-detail-container {
  padding: var(--spacing-5);
}

.detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--spacing-3);
}

.header-title {
  font-size: 21px;
  font-weight: bold;
}

.button-group {
  display: flex;
  justify-content: flex-end;
}

.label {
  font-weight: bold;
}

.subsidy-info {
  font-size: 14px;
  margin-right: var(--spacing-1);
  word-break: break-word;
}

.subsidy-type {
  color: black;
}

.card-content {
  padding: 0;
  overflow: hidden;
}

.card-content > * {
  margin-bottom: var(--spacing-3);
}

.title {
  font-size: var(--title-font-size);
  font-weight: bold;
}

.divider {
  margin: var(--spacing-3) 0;
  border-top: 1px solid var(--border-grey-color);
  height: 1px;
}

.detail {
  color: var(--primary-font-color);
  margin: var(--spacing-6) 0;
}

.detail .label {
  font-size: 17px;
  width: 100%;
}

.edit-admin {
  margin-top: var(--spacing-2);
}
</style>

<style lang="scss">
@media screen and (max-width: 1200px) {
  .el-col-12 {
    width: 100%;
  }
  .el-col-12:nth-child(2) {
    margin-top: var(--spacing-3);
  }
}
</style>
