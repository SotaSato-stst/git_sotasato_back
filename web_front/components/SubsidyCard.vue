<template>
  <el-card class="card clearfix">
    <el-container>
      <el-aside width="60px" class="card-aside">
        <el-avatar
          :size="54"
          :src="logoUrl(subsidy)"
          class="background-white"
        ></el-avatar>
        <div v-if="subsidy.supplierType !== city" class="supplier label">
          <div class="supplier">
            {{ supplierName(subsidy) }}
          </div>
          <div class="supplier">
            <!-- {{ supplierPrefectureName(subsidy) }} -->
          </div>
        </div>
      </el-aside>
      <el-container class="card-container">
        <el-header height="32px" class="card-header">
          <el-tag
            v-if="subsidy.subsidyCategory == 'hojo'"
            type="info"
            effect="plain"
            class="subsidy-type"
          >
            補助金
          </el-tag>
          <el-tag
            v-if="subsidy.subsidyCategory == 'josei'"
            type="info"
            effect="plain"
            class="subsidy-type"
          >
            助成金
          </el-tag>
          <span class="header-info">
            <span v-if="subsidy.priceMax" class="label">
              上限金額:
              {{ convertToJPY(subsidy.priceMax) }}円
            </span>
            <span v-else class="label"></span>
          </span>
          <span class="header-info">
            <span v-if="subsidy.level" class="label"
              >申請難易度:{{ starView(subsidy.level) }}</span
            >
            <span v-else class="label"></span>
          </span>
          <span class="header-info">
            募集期間:
            <span v-if="subsidy.endTo" class="label">
              {{ dateFormatter(subsidy.startFrom) }}
              ~
              {{ dateFormatter(subsidy.endTo) }}
            </span>
            <span v-else class="label">
              {{ dateFormatter(subsidy.startFrom) }}
              ~
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
          <div class="title">
            {{ subsidy.title }}
          </div>
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
import {defineComponent, PropType} from '@vue/composition-api'
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
  setup(_props) {
    const convertToJPY = (price: number) => {
      const format = Intl.NumberFormat('ja-JP', {
        notation: 'compact',
        currency: 'JPY',
      })
      const oku = 100000000
      if (price > oku) {
        const underOKuDigitsNumber = 8
        const overDigits = price.toString().length - underOKuDigitsNumber
        const jpMan = Number(price.toString().substr(overDigits))
        const underOku = format.format(jpMan)
        const overOku = format.format(price)
        return overOku + underOku
      } else {
        return format.format(price)
      }
    }
    const supplierName = (subsidy: Subsidy) => {
      if (subsidy.supplierType === 'ministry') {
        return subsidy.ministry.name
      } else if (subsidy.supplierType === 'prefecture') {
        return subsidy.prefecture.name
      } else if (subsidy.supplierType === 'city') {
        return subsidy.city.name
      } else {
        return ''
      }
    }
    // const supplierPrefectureName = (subsidy: Subsidy) => {
    //   if (subsidy.supplierType === 'city') {
    //     // const id = subsidy.city.prefectureId
    //     return subsidy.prefecture.name
    //   } else {
    //     return 'なし'
    //   }
    // }
    const logoUrl = (subsidy: Subsidy) => {
      if (subsidy.supplierType === 'ministry') {
        return subsidy.ministry.logoUrl
      } else if (subsidy.supplierType === 'prefecture') {
        return subsidy.prefecture.logoUrl
      } else if (subsidy.supplierType === 'city') {
        return subsidy.city.logoUrl
      } else {
        return ''
      }
    }
    const starView = (num: number) => {
      return '★'.repeat(num) + '☆'.repeat(5 - num)
    }
    const dateFormatter = (date: Date) => {
      const dateformat = new Intl.DateTimeFormat('ja-JP', {
        year: 'numeric',
        month: 'narrow',
        day: 'numeric',
      })
      return dateformat.format(new Date(date))
    }
    return {
      convertToJPY,
      dateFormatter,
      starView,
      supplierName,
      logoUrl,
      // supplierPrefectureName,
    }
  },
})
</script>
<style lang="postcss" scoped>
.card {
  overflow: auto;
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

.card-aside {
  height: 100%;
  text-align: center;
}

.background-white {
  background-color: white;
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
