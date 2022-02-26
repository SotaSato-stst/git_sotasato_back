<template>
  <el-card class="card clearfix">
    <el-container>
      <supplier-information :subsidy="subsidy" />
      <el-container class="card-container">
        <el-header height="32px" class="card-header">
          <el-tag type="info" effect="plain" class="subsidy-type">
            {{ subsidyCategoryLabel(subsidy.subsidyCategory) }}
          </el-tag>
          <span v-if="subsidy.priceMax" class="feature-label">
            <span class="label">
              上限金額:
              {{ convertToShortJPY(subsidy.priceMax) }}円
            </span>
          </span>
          <span v-if="dateRange()" class="feature-label">
            募集期間:
            <span class="label">
              {{ dateRange() }}
            </span>
          </span>
          <favorite-button :subsidy="subsidy" />
        </el-header>
        <el-main class="card-content">
          <a class="title" @click="clickSubsidy(subsidy.id)">
            {{ subsidy.title }}
          </a>
          <div class="target-container">
            <span class="label target">対象</span>
            <span class="target">
              {{ subsidy.targetDetail }}
            </span>
          </div>
          <div class="feature-labels">
            <span v-if="subsidy.level" class="feature-label">
              <span class="label">
                申請難易度:{{ starView(subsidy.level) }}
              </span>
            </span>
            <span v-if="subsidy.supportRatioMax" class="feature-label">
              <span class="label">
                最大支援割合:
                {{ subsidy.supportRatioMax }}
              </span>
            </span>
            <span v-if="subsidy.supportRatioMin" class="feature-label">
              <span class="label">
                最小支援割合:
                {{ subsidy.supportRatioMin }}
              </span>
            </span>
          </div>
        </el-main>
      </el-container>
    </el-container>
  </el-card>
</template>
<script lang="ts">
import {defineComponent, PropType, useRouter} from '@nuxtjs/composition-api'
import {Subsidy} from '@/types/Subsidy'
import {convertToJpDate} from '@/utils/dateFormatter'
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
    const subsidy = props.subsidy
    const clickSubsidy = (subsidyId: number) => {
      router.push('/subsidies/' + subsidyId)
    }

    const dateRange = (): string | null => {
      if (subsidy.startFrom && subsidy.endTo) {
        const startFrom = new Date(subsidy.startFrom)
        const endTo = new Date(subsidy.endTo)
        const diffYear = startFrom.getFullYear() !== endTo.getFullYear()
        return `${convertToJpDate(startFrom)} ~ ${convertToJpDate(
          endTo,
          diffYear,
        )}`
      } else if (subsidy.startFrom && !subsidy.endTo) {
        const startFrom = new Date(subsidy.startFrom)
        return `${convertToJpDate(startFrom)} ~`
      } else if (!subsidy.startFrom && subsidy.endTo) {
        const endTo = new Date(subsidy.endTo)
        return `~ ${convertToJpDate(endTo)}`
      } else {
        return null
      }
    }

    return {
      clickSubsidy,
      convertToShortJPY,
      convertToJpDate,
      starView,
      subsidyCategoryLabel,
      dateRange,
    }
  },
})
</script>
<style lang="postcss" scoped>
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

.label {
  font-weight: bold;
}

.card-header {
  padding: 0;
}

.card-header > * {
  margin-left: var(--spacing-1);
}

.feature-label {
  font-size: 14px;
  margin-right: var(--spacing-2);
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
  overflow: visible;
}

.title {
  font-size: 18px;
  font-weight: bold;
  text-decoration-line: underline;
  cursor: pointer;
}

.target-container {
  display: flex;
  overflow: hidden;
  text-overflow: ellipsis;
  height: var(--spacing-10);
  margin-top: var(--spacing-5);
}

.target {
  font-size: 12px;
  width: 100%;
  margin: auto;
}

.target-container > .label {
  width: var(--spacing-16);
  text-align: center;
  margin-top: var(--spacing-3);
}

.feature-labels {
  margin-top: var(--spacing-4);
}
</style>
