<template>
  <el-menu
    :default-active="selectedPage"
    class="header-menu"
    mode="horizontal"
    active-text-color="var(--primary-color)"
    @select="handleSelect"
  >
    <el-menu-item index="new">
      <i class="el-icon-s-order new"></i>新着 (12件)
    </el-menu-item>
    <el-menu-item index="ranking">
      <i class="el-icon-s-flag flag"></i>人気
    </el-menu-item>
    <el-menu-item index="favorite">
      <i class="el-icon-star-on star"></i>保存済み
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
  color: var(--text-color);
}

.header-menu > li > i {
  font-size: 16px;
  width: fit-content;
}

.star,
.header-menu > li.is-active > i.star {
  color: var(--hilight-yellow);
}

.flag,
.header-menu > li.is-active > i.flag {
  color: #f48c06;
}

.new,
.header-menu > li.is-active > i.new {
  color: #48cae4;
}
</style>
