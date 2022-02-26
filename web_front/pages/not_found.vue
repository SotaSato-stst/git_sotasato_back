<template>
  <div class="container">
    <el-empty description="ページが存在しません">
      <el-button type="primary" @click="redirectToTop">トップへ戻る</el-button>
    </el-empty>
  </div>
</template>

<script lang="ts">
import {defineComponent, useRouter} from '@nuxtjs/composition-api'

export default defineComponent({
  name: 'NotFoundPage',
  layout: 'error',
  props: {
    error: {
      type: Object,
      default: null,
    },
  },
  setup(_props) {
    const router = useRouter()
    const redirectToTop = () => {
      router.replace('/')
    }

    return {redirectToTop}
  },
  head(): object {
    return {
      title: '404',
    }
  },
})
</script>

<style lang="postcss" scoped>
.container {
  display: flex;
  justify-content: center;
  width: 100%;
  height: 100%;
}
</style>
