<template>
  <el-card class="card clearfix">
    <el-container>
      <supplier-information :subsidy="subsidy" />
      <el-container class="card-container">
        <el-header height="32px" class="card-header">
          <el-tag type="info" effect="plain" class="subsidy-type">
            {{ subsidyCategoryLabel(subsidy.subsidyCategory) }}
          </el-tag>
          <span
            v-if="subsidy.startFrom || subsidy.endTo"
            class="vertical-align"
          >
            <span class="common-font"> 募集期間: </span>
            <span>
              {{ convertDateRange(subsidy.startFrom, subsidy.endTo) }}
            </span>
          </span>
          <favorite-button :subsidy="subsidy" />
        </el-header>
        <el-main class="card-content">
          <div v-if="subsidy.catchCopy" class="catch-copy-font common-font">
            {{ subsidy.catchCopy }}
          </div>
          <div class="title-font">
            <a class="title common-font" @click="clickSubsidy(subsidy.id)">
              {{ subsidy.title }}
            </a>
          </div>
          <div class="flex-box">
            <div class="flex-child-first">
              <div v-if="subsidy.priceMax">
                <span class="feature-label common-font"> 上限金額: </span>
                <span class="accent-part common-font">
                  {{ convertToShortJPY(subsidy.priceMax) }}円</span
                >
              </div>
            </div>
            <div class="flex-child-second">
              <div v-if="subsidy.supportRatioMax">
                <span class="feature-label common-font"> 最大支援割合: </span>
                <span class="accent-part common-font margin-right-4">
                  {{ subsidy.supportRatioMax }}
                </span>
              </div>
              <div v-if="subsidy.supportRatioMin">
                <span class="feature-label common-font"> 最小支援割合: </span>
                <span class="accent-part common-font">
                  {{ subsidy.supportRatioMin }}
                </span>
              </div>
            </div>
          </div>
          <div class="tag-wrapper">
            <span
              v-for="keyword in subsidy.keywords"
              :key="keyword"
              class="tag-card"
            >
              {{ keyword }}
            </span>
          </div>
          <div class="detail-width">
            <p v-if="subsidy.keywords.length == 0" class="detail-wrapper">
              <span class="detail-wrapper-span">
                {{ subsidy.detail }}
              </span>
            </p>
          </div>
        </el-main>
      </el-container>
    </el-container>
  </el-card>
</template>
<script lang="ts">
import {defineComponent, PropType, useRouter} from '@nuxtjs/composition-api'
import {Subsidy} from '@/types/Subsidy'
import {convertDateRange} from '@/utils/dateFormatter'
import {convertToShortJPY} from '@/utils/numberFormatter'
import {starView} from '@/utils/starView'
import SupplierInformation from '@/components/subsidies/SupplierInformation.vue'
import FavoriteButton from '@/components/subsidies/FavoriteButton.vue'
import {subsidyCategoryLabel} from '@/utils/enumKeyToName'

export default defineComponent({
  components: {
    SupplierInformation,
    FavoriteButton,
  },
  props: {
    subsidy: {
      type: Object as PropType<Subsidy>,
      required: true,
    },
  },
  setup(_props) {
    const router = useRouter()
    const clickSubsidy = (subsidyId: number) => {
      router.push('/subsidies/' + subsidyId)
    }

    return {
      clickSubsidy,
      convertToShortJPY,
      convertDateRange,
      starView,
      subsidyCategoryLabel,
    }
  },
})
</script>

<style lang="postcss" scoped>
@import url('https://fonts.googleapis.com/css2?family=Noto+Serif+JP&family=Poppins:wght@700&display=swap');

.card {
  overflow: auto;
}

.common-font {
  font-family: Poppins, sans-serif;
}

.catch-copy-font {
  font-weight: bold;
  font-size: var(--spacing-4);
  margin: var(--spacing-4) 0;
}

.title-font {
  margin: var(--spacing-4) 0;
}

.title {
  font-size: var(--spacing-6);
  font-weight: bold;
  color: #005dba;
  cursor: pointer;
}

.clearfix::before,
.clearfix::after {
  display: table;
  content: '';
}

.clearfix::after {
  clear: both;
}

.vertical-align {
  vertical-align: middle;
}

.card-header {
  padding: 0;
}

.card-header > * {
  margin-left: var(--spacing-1);
}

.feature-label {
  font-size: 14px;
  font-weight: bold;
  margin-right: var(--spacing-2);
}

.card-container {
  margin-left: var(--spacing-4);
}

.subsidy-type {
  color: black;
}

.card-content {
  padding: 0;
  overflow: visible;
}

.flex-box {
  display: flex;
  margin-top: var(--spacing-4);
}

.flex-child-first {
  margin: 0 var(--spacing-8) 0 0;
}

.flex-child-second {
  display: flex;
}

.margin-right-4 {
  margin-right: var(--spacing-4);
}

.accent-part {
  color: #be1b59;
  font-size: var(--spacing-6);
  font-weight: bold;
}

.tag-wrapper {
  margin: var(--spacing-6) 0 var(--spacing-4) 0;
}

.tag-card {
  background-color: #eee;
  font-size: 14px;
  border-radius: var(--spacing-1);
  padding: var(--spacing-2) var(--spacing-3);
  margin-right: var(--spacing-4);
}

.detail-width {
  width: 70%;
}

.detail-wrapper {
  border-top: solid 1px #cfcfcf;
  padding-top: var(--spacing-4);
}

p {
  color: black;
  height: calc(1.5em * 2);
  line-height: 1.5em;
  overflow: hidden;
  position: relative;
  word-wrap: break-word;
}

p span {
  margin-right: 1em;
}

p::before {
  background: linear-gradient(to right, #fff0 0%, #fff 30%);
  bottom: 0%;
  content: '…';
  padding-left: 1em;
  position: absolute;
  right: 0%;
}

p::after {
  background: #fff;
  content: '';
  height: 100%;
  position: absolute;
  width: 100%;
}
</style>
