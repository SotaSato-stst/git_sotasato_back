<template>
  <div class="subsidy-detail-container">
    <el-card v-if="subsidy">
      <el-container>
        <el-container class="card-container">
          <el-header height="32px" class="subsidy-header">
            <el-tag type="info" effect="plain" class="subsidy-type">
              {{ subsidyCategoryLabel(subsidy.subsidyCategory) }}
            </el-tag>
            <favorite-button :subsidy="subsidy" />
          </el-header>
          <el-main class="card-content">
            <div class="title">{{ subsidy.title }}</div>
            <div class="subsidy-info">
              <span class="label">発行: </span>
              <span v-if="subsidy.ministry">{{ subsidy.ministry.name }}</span>
              <span v-if="subsidy.prefecture">
                {{ subsidy.prefecture.name }}
              </span>
              <span v-if="subsidy.city">{{ subsidy.city.name }}</span>
            </div>
            <div v-if="subsidy.priceMax" class="subsidy-info">
              <span class="label">上限金額: </span>
              {{ convertToShortJPY(subsidy.priceMax) }}円
            </div>
            <div
              v-if="subsidy.supportRatioMin || subsidy.supportRatioMax"
              class="subsidy-info"
            >
              <span class="label">支援割合: </span>
              {{ subsidy.supportRatioMin }}
              ~
              {{ subsidy.supportRatioMax }}
            </div>
            <div class="subsidy-info">
              <span class="label">募集期間: </span>
              <span v-if="subsidy.startFrom || subsidy.endTo">
                {{ convertDateRange(subsidy.startFrom, subsidy.endTo) }}
              </span>
              <span v-else>未定</span>
            </div>
            <div v-if="subsidy.level" class="subsidy-info">
              <span class="label">申請難易度: </span>
              {{ starView(subsidy.level) }}
            </div>
            <div class="subsidy-info">
              <span class="label">URL: </span>
              <a :href="subsidy.url" target="_blank">{{ subsidy.url }}</a>
            </div>
          </el-main>
        </el-container>
      </el-container>
      <div class="divider" />
      <div class="detail">
        <span class="label">対象</span>
        <!-- eslint-disable vue/no-v-html -->
        <div
          class="content subsidy-detail-markdown-content"
          v-html="parseMarkdown(subsidy.targetDetail)"
        />
      </div>
      <div class="detail">
        <span class="label">支援内容</span>
        <div
          class="content subsidy-detail-markdown-content"
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
import FavoriteButton from '@/components/subsidies/FavoriteButton.vue'
import {routingService} from '~/services/routingService'

export default defineComponent({
  name: 'SubsidyDetailPage',
  components: {
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

.label {
  font-weight: bold;
}

.subsidy-header {
  padding: 0;
  display: flex;
  justify-content: space-between;
  align-content: center;
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
  margin-top: var(--spacing-4);
  padding: 0;
  overflow: hidden;
}

.card-content > * {
  margin-bottom: var(--spacing-3);
}

.title {
  font-size: 22px;
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
.subsidy-detail-markdown-content {
  margin-top: var(--spacing-3);
  font-size: 16px;
  white-space: pre-line;

  h1,
  h2,
  h3,
  h4,
  h5,
  h6 {
    margin-block-start: var(--spacing-3);
  }

  * {
    margin-block-start: 0;
    margin-block-end: 0;
  }

  em {
    font-style: normal;
  }

  ul {
    list-style-type: initial;
    line-height: 1;
    margin-inline-start: 24px;
    margin-inline-end: 0;
    padding-inline-start: 0;
  }

  table {
    border-collapse: collapse;
  }

  th,
  td {
    border: solid 1px #adb5bd;
    padding: var(--spacing-2);
  }
}
</style>
