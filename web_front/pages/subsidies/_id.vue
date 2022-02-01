// TODO:ikegaki 詳細ページをつくる
<template>
  <div class="container">
    <div v-if="subsidy" class="background">
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
            <a class="title" @click="clickSubsidy(subsidy.id)">
              {{ subsidy.title }}
            </a>
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
      <div class="detail">
        <span class="label">対象</span>
        <div class="content">
          {{ subsidy.targetDetail }}
        </div>
        <span class="label">支援内容</span>
        <div class="content">
          {{ subsidy.detail }}
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import {
  computed,
  defineComponent,
  onMounted,
  useRoute,
} from '@nuxtjs/composition-api'
import {subsidiesModule} from '~/store'
import {convertToJpDate} from '@/utils/dateFormatter'
import {convertToShortJPY} from '@/utils/numberFormatter'
import {starView} from '@/utils/starView'
import {subsidyCategoryLabel} from '@/utils/subsidyCategoryLabel'
export default defineComponent({
  name: 'SubsidyDetailPage',
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
})
</script>

<style lang="postcss" scoped>
.container > * {
  margin-bottom: var(--spacing-4);
}

.block {
  display: block;
  margin-top: var(--spacing-4);
  margin-bottom: var(--spacing-4);
}

.background {
  background-color: var(--white);
  padding: var(--spacing-5);
  border: 1px solid var(--border-grey-color);
  color: var(--primary-font-color);
  border-radius: var(--spacing-1);
}

.card {
  overflow: auto;
}

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
  font-size: 12px;
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
  text-decoration-line: underline;
  cursor: pointer;
}

.favorite {
  float: right;
}

.target {
  font-size: 12px;
  width: 100%;
}

.detail {
  padding-top: var(--spacing-5);
  margin-top: var(--spacing-5);
  border-top: 1px solid var(--border-grey-color);
}

.detail .label {
  font-size: 14px;
  width: 100%;
}

.detail .content {
  font-size: 12px;
  line-height: 18px;
  margin: var(--spacing-5) 0;
}
</style>
