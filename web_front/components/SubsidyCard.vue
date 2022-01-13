<template>
  <el-card class="card clearfix">
    <el-container>
      <el-aside width="60px" class="card-aside">
        <el-avatar :size="54" :src="circleUrl"></el-avatar>
        <div class="supplier label">発行機関</div>
        <div class="supplier">茨城県</div>
        <div class="supplier">つくば市</div>
      </el-aside>
      <el-container class="card-container">
        <el-header height="32px" class="card-header">
          <el-tag type="info" effect="plain" class="subsidy-type" hit="true">
            補助金
          </el-tag>
          <span class="header-info">
            上限金額: <span class="label">1億円</span>
          </span>
          <span class="header-info">
            申請難易度: <span class="label">★★★★☆</span>
          </span>
          <span class="header-info">
            募集期間: <span class="label">2022年4月1日~5月1日</span>
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
            ものづくり・商業・サービス生産性向上促進補助金
          </div>
          <div class="target-container">
            <span class="label target">対象</span>
            <span class="target">
              以下の要件を満たす事業計画（3～5年）を策定し実施する中小企業・小規模事業者等であること。
              ①付加価値額の年率3％以上向上 ②給与支給総額の年率1.5％以上向上
              ③事業場内最低賃金を地域別最低賃金30円以上向上
            </span>
          </div>
        </el-main>
      </el-container>
    </el-container>
  </el-card>
</template>

<script lang="ts">
import Vue from 'vue'
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

export default Vue.extend({
  name: 'DefaultBanner',
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
  props: {},
  data() {
    return {}
  },
  computed: {},
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
