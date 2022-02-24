<template>
  <el-container class="container">
    <el-aside class="left-side-menu" width="var(--header-width)">
      <viewed-subsidies />
    </el-aside>
    <el-main>
      <el-card v-if="subsidy">
        <el-container>
          <supplier-information :subsidy="subsidy" />
          <el-container class="card-container">
            <el-header height="32px" class="card-header">
              <div>
                <el-tag type="info" effect="plain" class="subsidy-type">
                  {{ subsidyCategoryLabel(subsidy.subsidyCategory) }}
                </el-tag>
                <span v-if="subsidy.priceMax" class="header-info">
                  <span class="label">
                    上限金額:
                    {{ convertToShortJPY(subsidy.priceMax) }}円
                  </span>
                </span>
                <span
                  v-if="subsidy.supportRatioMin || subsidy.supportRatioMax"
                  class="header-info"
                >
                  <span class="label">
                    支援割合:
                    {{ subsidy.supportRatioMin }}
                    ~
                    {{ subsidy.supportRatioMax }}
                  </span>
                </span>
                <span v-if="subsidy.level" class="header-info">
                  <span class="label">
                    申請難易度:{{ starView(subsidy.level) }}
                  </span>
                </span>
              </div>
              <div>
                <el-button
                  v-if="isAdmin"
                  size="mini"
                  @click="showAdmin(subsidy.id)"
                >
                  管理画面で編集する
                </el-button>
                <favorite-button :subsidy="subsidy" />
              </div>
            </el-header>
            <el-main class="card-content">
              <div class="title">{{ subsidy.title }}</div>
              <div class="header-info">
                <span class="label">募集期間: </span>
                {{ convertToJpDate(subsidy.startFrom) }}
                ~
                {{ subsidy.endTo && convertToJpDate(subsidy.endTo) }}
              </div>
              <div class="header-info">
                <span class="label">URL: </span>
                <a :href="subsidy.url" target="_blank">{{ subsidy.url }}</a>
              </div>
            </el-main>
          </el-container>
        </el-container>
        <div class="divider" />
        <div class="detail">
          <span class="label">対象</span>
          <div class="content" v-html="parseMarkdown(subsidy.targetDetail)" />
        </div>
        <div class="detail">
          <span class="label">支援内容</span>
          <div class="content" v-html="parseMarkdown(subsidy.detail)" />
        </div>
      </el-card>
    </el-main>
    <el-aside width="316px">
      <side-right-menu />
    </el-aside>
  </el-container>
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
import {Container, Aside, Main, Card} from 'element-ui'
import {marked} from 'marked'
import {subsidiesModule, accountModule} from '@/store'
import {convertToJpDate} from '@/utils/dateFormatter'
import {convertToShortJPY} from '@/utils/numberFormatter'
import {starView} from '@/utils/starView'
import {subsidyCategoryLabel} from '@/utils/enumKeyToName'
import FavoriteButton from '@/components/subsidies/FavoriteButton.vue'
import SupplierInformation from '@/components/subsidies/SupplierInformation.vue'
import SideRightMenu from '@/components/layouts/SideRightMenu.vue'
import ViewedSubsidies from '@/components/subsidies/ViewedSubsidies.vue'
import {routingService} from '~/services/routingService'

export default defineComponent({
  name: 'SubsidyDetailPage',
  components: {
    [`${Container.name}`]: Container,
    [`${Aside.name}`]: Aside,
    [`${Main.name}`]: Main,
    [`${Card.name}`]: Card,
    SupplierInformation,
    FavoriteButton,
    SideRightMenu,
    ViewedSubsidies,
  },

  setup(_props) {
    const route = useRoute()
    const router = useRouter()
    const pageId = Number(route.value.params.id)
    const subsidy = computed(() => subsidiesModule.subsidy)
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
      }
    })

    onUnmounted(() => {
      subsidiesModule.setSubsidy(null)
    })

    return {
      convertToShortJPY,
      convertToJpDate,
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
.clearfix::before,
.clearfix::after {
  display: table;
  content: '';
}

.clearfix::after {
  clear: both;
}

.card-aside {
  height: 100%;
  text-align: center;
}

.logo {
  background-color: var(--white);
  border: solid 1px var(--border-grey-color);
}

.supplier {
  font-size: 12px;
  margin-top: var(--spacing-2);
}

.label {
  font-weight: bold;
}

.card-header {
  padding: 0;
  display: flex;
  justify-content: space-between;
}

.header-info {
  font-size: 14px;
  margin-right: var(--spacing-1);
}

.card-container {
  margin-left: var(--spacing-4);
}

.subsidy-type {
  color: black;
}

.card-content {
  margin-top: var(--spacing-4);
  padding: 0;
}

.card-content > * {
  margin-bottom: var(--spacing-3);
}

.title {
  font-size: 18px;
  font-weight: bold;
}

.favorite {
  float: right;
}

.block {
  display: block;
  margin-top: var(--spacing-4);
  margin-bottom: var(--spacing-4);
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
  font-size: 16px;
  width: 100%;
}

.detail .content {
  font-size: 14px;
  white-space: pre-line;
}
</style>

<style>
em {
  font-style: normal;
}
</style>
