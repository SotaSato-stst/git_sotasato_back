<template>
  <el-card class="card clearfix">
    <el-container>
      <el-aside width="60px" class="card-aside">
        <el-avatar
          :size="54"
          :src="logoUrl(subsidy.supplierType)"
          class="logo"
        ></el-avatar>
        <div class="supplier label">発行機関</div>
        <div v-if="subsidy.supplierType == 'city'" class="supplier">
          {{ subsidy.prefecture && subsidy.prefecture.name }}
        </div>
        <div class="supplier">
          {{ supplierName(subsidy.supplierType) }}
        </div>
      </el-aside>
      <el-container class="card-container">
        <el-header height="32px" class="card-header">
          <el-tag type="info" effect="plain" class="subsidy-type">
            {{ subsidyCategoryLabel[subsidy.subsidyCategory] }}
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
          <el-button
            type="warning"
            icon="el-icon-star-off"
            size="mini"
            class="favorite"
            plain
          >
            保存
          </el-button>
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
import {Subsidy, SupplierType} from '@/types/Subsidy'
import {convertToJpDate} from '@/utils/dateFormatter'
import {convertToShortJPY} from '@/utils/numberFormatter'

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
    const subsidyCategoryLabel = {
      hojo: '補助金',
      josei: '助成金',
    }
    const supplierName = (supplierType: SupplierType) => {
      switch (supplierType) {
        case 'ministry':
          return props.subsidy.ministry?.name
        case 'prefecture':
          return props.subsidy.prefecture?.name
        case 'city':
          return props.subsidy.city?.name
      }
    }
    const logoUrl = (supplierType: SupplierType) => {
      switch (supplierType) {
        case 'ministry':
          return props.subsidy.ministry?.logoUrl
        case 'prefecture':
          return props.subsidy.prefecture?.logoUrl
        case 'city':
          return props.subsidy.city?.logoUrl
      }
    }
    const starView = (num: number) => {
      return '★'.repeat(num) + '☆'.repeat(5 - num)
    }
    return {
      clickSubsidy,
      subsidyCategoryLabel,
      convertToShortJPY,
      convertToJpDate,
      starView,
      supplierName,
      logoUrl,
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

.card-aside {
  height: 100%;
  text-align: center;
}

.logo {
  background-color: white;
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
  text-decoration-line: underline;
  cursor: pointer;
}

.favorite {
  float: right;
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
