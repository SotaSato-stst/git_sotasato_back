<template>
  <el-card>
    <el-container>
      <el-aside v-if="!$device.isMobile" width="60px" class="supplier">
        <supplier-information :subsidy="subsidy" />
      </el-aside>
      <el-container>
        <el-main class="card-container">
          <div>
            <div v-if="subsidy.catchCopy" class="catch-copy-font">
              【{{ subsidy.catchCopy }}】
            </div>
            <div :class="$device.isMobile ? '' : 'title-container'">
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
              class="price-container"
            >
              <div v-if="subsidy.priceMax">
                <span class="feature-label"> 上限金額: </span>
                <span class="accent-text">
                  {{ convertToShortJPY(subsidy.priceMax) }}円
                </span>
              </div>
              <div class="inner-price-container">
                <div v-if="subsidy.supportRatioMax">
                  <span class="feature-label"> 最大支援割合: </span>
                  <span class="accent-text">
                    {{ subsidy.supportRatioMax }}
                  </span>
                </div>
                <div v-if="subsidy.supportRatioMin">
                  <span class="feature-label"> 最小支援割合: </span>
                  <span class="accent-text">
                    {{ subsidy.supportRatioMin }}
                  </span>
                </div>
              </div>
            </div>
            <div v-if="subsidy.keywords.length > 0" class="tag-container">
              <el-tag
                v-for="keyword in keywords"
                :key="keyword"
                type="info"
                class="keyword-tag"
              >
                {{ keyword }}
              </el-tag>
            </div>
            <div v-if="subsidy.keywords.length == 0" class="detail-container">
              <span class="normal-text">
                {{ subsidy.detail.replaceAll('#', '') }}
              </span>
            </div>
          </div>
          <div class="footer-container">
            <div>
              <span class="normal-text">募集期間:</span>
              <span
                v-if="subsidy.startFrom || subsidy.endTo"
                class="normal-text"
              >
                {{ convertDateRange(subsidy.startFrom, subsidy.endTo) }}
              </span>
              <span v-else class="normal-text">未定</span>
            </div>
            <favorite-button :subsidy="subsidy" />
          </div>
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
.card-container {
  padding: 0;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  overflow: hidden;
}

.supplier {
  margin-right: var(--spacing-4);
  height: 168px;
}

.catch-copy-font {
  font-weight: bold;
  font-size: 17px;
  margin-bottom: var(--spacing-2);
}

.title-container {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.title {
  font-size: var(--title-font-size);
  font-weight: bold;
  color: var(--color-title);
  cursor: pointer;
}

.feature-label {
  font-size: 14px;
  font-weight: bold;
  margin-right: var(--spacing-2);
}

.price-container {
  display: flex;
  margin-top: var(--spacing-4);
}

.price-container > div {
  margin-right: var(--spacing-8);
  display: flex;
  flex-wrap: wrap;
  align-items: center;
}

.inner-price-container {
  display: flex;
}

.inner-price-container > div {
  margin-right: var(--spacing-3);
}

.accent-text {
  color: var(--color-accent);
  font-size: 22px;
  font-weight: bold;
  font-family: Poppins, sans-serif;
  width: max-content;
}

.normal-text {
  font-size: 14px;
}

.keyword-tag {
  font-size: 12px;
  color: var(--text-color);
  margin: var(--spacing-4) var(--spacing-3) 0 0;
}

.detail-container {
  color: var(--text-color);
  height: calc(1.5em * 4);
  line-height: 1.5em;
  overflow: hidden;
  position: relative;
  word-wrap: break-word;
  margin: var(--spacing-2) 0;
}

.detail-container > span {
  margin-right: 1em;
}

.detail-container ::before {
  background: linear-gradient(to right, var(--white) 30%);
  bottom: 0%;
  content: '…';
  padding-left: 1em;
  position: absolute;
  right: 0%;
}

.detail-container ::after {
  background: var(--white);
  content: '';
  height: 100%;
  position: absolute;
  width: 100%;
}

.footer-container {
  width: 100%;
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: var(--spacing-2);
}
</style>
