<template>
  <el-card class="card clearfix">
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
            <span class="label">申請難易度:{{ starView(subsidy.level) }}</span>
          </span>
          <span class="header-info">
            募集期間:
            <span class="label">
              {{ convertToJpDate(subsidy.startFrom) }}
              ~
              {{ subsidy.endTo && convertToJpDate(subsidy.endTo) }}
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
        </el-main>
      </el-container>
    </el-container>
  </el-card>
</template>
<script lang="ts">
import {defineComponent, PropType, useRouter} from '@nuxtjs/composition-api'
import {
  Container,
  Header,
  Aside,
  Main,
  Card,
  Button,
  Avatar,
  Tag,
} from 'element-ui'
import {Subsidy} from '@/types/Subsidy'
import {convertToJpDate} from '@/utils/dateFormatter'
import {convertToShortJPY} from '@/utils/numberFormatter'
import {starView} from '@/utils/starView'
import SupplierInformation from '@/components/SupplierInformation.vue'
import FavoriteButton from '@/components/FavoriteButton.vue'
import {subsidyCategoryLabel} from '@/utils/subsidyCategoryLabel'

export default defineComponent({
  components: {
    [`${Container.name}`]: Container,
    [`${Header.name}`]: Header,
    [`${Aside.name}`]: Aside,
    [`${Main.name}`]: Main,
    [`${Card.name}`]: Card,
    [`${Button.name}`]: Button,
    [`${Avatar.name}`]: Avatar,
    [`${Tag.name}`]: Tag,
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
      convertToJpDate,
      starView,
      subsidyCategoryLabel,
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
}

.target-container > .label {
  width: var(--spacing-16);
  text-align: center;
  margin-top: var(--spacing-3);
}
</style>
