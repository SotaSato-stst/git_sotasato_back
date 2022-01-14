<template>
  <el-menu
    :default-active="selectedPage"
    class="header-menu"
    mode="horizontal"
    background-color="#2a6f97"
    text-color="#fff"
    active-text-color="var(--hilight-yellow)"
    @select="handleSelect"
  >
    <el-menu-item index="new">
      <i class="el-icon-s-order"></i>新着 (12件)
    </el-menu-item>
    <el-menu-item index="ranking">
      <i class="el-icon-s-flag"></i>人気
    </el-menu-item>
    <el-menu-item index="favorite">
      <i class="el-icon-star-on"></i>保存済み
    </el-menu-item>
  </el-menu>
</template>

<script lang="ts">
import Vue from 'vue'
import {Menu, MenuItem} from 'element-ui'

export default Vue.extend({
  name: 'GlobalHeader',
  components: {
    [`${Menu.name}`]: Menu,
    [`${MenuItem.name}`]: MenuItem,
  },
  data() {
    return {
      selectedPage: 'new',
    }
  },
  methods: {
    handleSelect(value: string) {
      console.log(value)
    },
  },
})
</script>

<style lang="postcss" scoped>
.header-menu > li {
  font-size: 14px;
  font-weight: bold;
  width: fit-content;
}

.header-menu > li > i {
  font-size: 16px;
  width: fit-content;
  color: white;
}

.header-menu > li.is-active > i {
  color: var(--hilight-yellow);
}
</style>
