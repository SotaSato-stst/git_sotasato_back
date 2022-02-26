<template>
  <div v-if="loading">
    <el-card class="card">
      <el-skeleton />
    </el-card>
    <el-card class="card">
      <el-skeleton />
    </el-card>
    <el-card class="card">
      <el-skeleton />
    </el-card>
  </div>
</template>

<script lang="ts">
import {defineComponent} from '@nuxtjs/composition-api'

export default defineComponent({
  name: 'CardLoading',
  props: {
    loading: {
      type: Boolean,
      default: false,
    },
  },
})
</script>

<style lang="postcss" scoped>
.card {
  height: var(--spacing-43);
  margin-bottom: var(--spacing-4);
  opacity: 0.5;
}

.loading {
  margin: auto;
  height: 100%;
  width: 100%;
}
</style>
