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
            class="vertical-align feature-label"
          >
            <span> 募集期間: </span>
            <span>
              {{ convertDateRange(subsidy.startFrom, subsidy.endTo) }}
            </span>
          </span>
          <favorite-button :subsidy="subsidy" />
        </el-header>
        <el-main class="card-content">
          <div v-if="subsidy.catchCopy" class="catch-copy-font">
            【{{ subsidy.catchCopy }}】
          </div>
          <div class="title-wrapper">
            <a class="title" @click="clickSubsidy(subsidy.id)">
              {{ subsidy.title }}
            </a>
          </div>
          <div
            v-if="
              subsidy.priceMax ||
              subsidy.supportRatioMax ||
              subsidy.supportRatioMin
            "
            class="flex-box"
          >
            <div v-if="subsidy.priceMax">
              <span class="feature-label"> 上限金額: </span>
              <span class="accent-part">
                {{ convertToShortJPY(subsidy.priceMax) }}円</span
              >
            </div>
            <div class="inner-flex-box">
              <div v-if="subsidy.supportRatioMax">
                <span class="feature-label"> 最大支援割合: </span>
                <span class="accent-part margin-right-4">
                  {{ subsidy.supportRatioMax }}
                </span>
              </div>
              <div v-if="subsidy.supportRatioMin">
                <span class="feature-label"> 最小支援割合: </span>
                <span class="accent-part">
                  {{ subsidy.supportRatioMin }}
                </span>
              </div>
            </div>
          </div>
          <div v-if="subsidy.keywords.length > 0" class="tag-wrapper">
            <el-tag
              v-for="keyword in keywords"
              :key="keyword"
              type="info"
              class="tag-card"
            >
              {{ keyword }}
            </el-tag>
          </div>
          <p v-if="subsidy.keywords.length == 0" class="detail-wrapper">
            <span>
              {{ subsidy.detail }}
            </span>
          </p>
        </el-main>
      </el-container>
    </el-container>
  </el-card>
</template>
<script lang="ts">
import {
  defineComponent,
  PropType,
  useRouter,
  computed,
} from '@nuxtjs/composition-api'
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

  setup(props) {
    const router = useRouter()
    const clickSubsidy = (subsidyId: number) => {
      router.push('/subsidies/' + subsidyId)
    }
    const keywords = computed(() => props.subsidy.keywords.slice(0, 5))

    return {
      clickSubsidy,
      convertToShortJPY,
      convertDateRange,
      starView,
      subsidyCategoryLabel,
      keywords,
    }
  },
})
</script>

<style lang="postcss" scoped>
.card {
  overflow: auto;
}

.catch-copy-font {
  font-weight: bold;
  font-size: 16px;
  margin: var(--spacing-4) 0;
}

.title-wrapper {
  margin-top: var(--spacing-4);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.title {
  font-size: 24px;
  font-weight: bold;
  color: var(--color-title);
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
  color: var(--black);
}

.card-content {
  padding: 0;
  overflow: visible;
}

.flex-box {
  display: flex;
  margin-top: var(--spacing-4);
}

.flex-box > div {
  margin-right: var(--spacing-8);
}

.inner-flex-box {
  display: flex;
}

.margin-right-4 {
  margin-right: var(--spacing-4);
}

.accent-part {
  color: var(--color-accent);
  font-size: 24px;
  font-weight: bold;
  font-family: Poppins, sans-serif;
}

.tag-card {
  font-size: 14px;
  margin: var(--spacing-4) var(--spacing-4) 0 0;
}

.detail-wrapper {
  color: var(--color-detail);
  height: calc(1.5em * 2);
  line-height: 1.5em;
  overflow: hidden;
  position: relative;
  word-wrap: break-word;
}

.detail-wrapper > span {
  margin-right: 1em;
}

.detail-wrapper ::before {
  background: linear-gradient(to right, var(--white) 30%);
  bottom: 0%;
  content: '…';
  padding-left: 1em;
  position: absolute;
  right: 0%;
}

.detail-wrapper ::after {
  background: var(--white);
  content: '';
  height: 100%;
  position: absolute;
  width: 100%;
}
</style>
