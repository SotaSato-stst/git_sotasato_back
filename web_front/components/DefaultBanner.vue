<template>
  <el-card class="card" shadow="never">バナー</el-card>
</template>

<script lang="ts">
import Vue from 'vue'
import {Card} from 'element-ui'

export default Vue.extend({
  name: 'DefaultBanner',
  components: {[`${Card.name}`]: Card},
  props: {},
  data() {
    return {}
  },
  computed: {},
})
</script>

<style lang="postcss" scoped>
.card {
  width: var(--default-banner-width);
  height: var(--default-banner-height);
}
</style>
