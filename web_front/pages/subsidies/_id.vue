<template>
  <el-container class="container">
    <el-aside class="left-side-menu" width="var(--header-width)"> </el-aside>
    <el-main>
      <el-card v-if="subsidy">
        <el-container>
          <supplier-information :subsidy="subsidy" />
          <el-container class="card-container">
            <el-header height="32px" class="card-header">
              <el-tag type="info" effect="plain" class="subsidy-type">
                {{ subsidyCategoryLabel(subsidy.subsidyCategory) }}
              </el-tag>
              <span v-if="subsidy.priceMax" class="header-info">
                <span class="label">
                  上限金額:
                  {{ convertToShortJPY(subsidy.priceMax) }}円
                </span>
              </span>
              <span v-if="subsidy.level" class="header-info">
                <span class="label">
                  申請難易度:{{ starView(subsidy.level) }}
                </span>
              </span>
              <favorite-button :subsidy="subsidy" />
            </el-header>
            <el-main class="card-content">
              <div class="title">
                {{ subsidy.title }}
              </div>
              <span class="header-info">
                <span class="label block">
                  募集期間:
                  {{ convertToJpDate(subsidy.startFrom) }}
                  ~
                  {{ subsidy.endTo && convertToJpDate(subsidy.endTo) }}
                </span>
              </span>
              <span class="header-info">
                <span class="label block">
                  URL:
                  <a :href="subsidy.url" target="_blank">
                    {{ subsidy.url }}
                  </a>
                </span>
              </span>
            </el-main>
          </el-container>
        </el-container>
        <div class="divider" />
        <div class="detail">
          <span class="label">対象</span>
          <div class="content">
            {{ subsidy.targetDetail }}
          </div>
        </div>
        <div class="detail">
          <span class="label">支援内容</span>
          <div class="content">
            {{ subsidy.detail }}
          </div>
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
  computed,
  defineComponent,
  onMounted,
  useRoute,
} from '@nuxtjs/composition-api'
import {Container, Aside, Main, Card} from 'element-ui'
import {subsidiesModule} from '~/store'
import {convertToJpDate} from '@/utils/dateFormatter'
import {convertToShortJPY} from '@/utils/numberFormatter'
import {starView} from '@/utils/starView'
import {subsidyCategoryLabel} from '@/utils/enumKeyToName'

export default defineComponent({
  name: 'SubsidyDetailPage',
  components: {
    [`${Container.name}`]: Container,
    [`${Aside.name}`]: Aside,
    [`${Main.name}`]: Main,
    [`${Card.name}`]: Card,
  },
  setup(_props) {
    const route = useRoute()
    const pageId = Number(route.value.params.id)
    const subsidy = computed(() => subsidiesModule.subsidy)

    onMounted(() => {
      subsidiesModule.getSubsidy(pageId)
    })

    return {
      subsidy,
      convertToShortJPY,
      convertToJpDate,
      starView,
      subsidyCategoryLabel,
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
}

.card-header > * {
  margin-left: var(--spacing-1);
}

.header-info {
  font-size: 14px;
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

.left-side-menu {
  background-color: white;
  width: 100%;
  height: 100%;
}
</style>
