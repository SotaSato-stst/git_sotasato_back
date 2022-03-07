<template>
  <div class="container">
    <el-empty :description="message()">
      <el-button type="primary" @click="redirectToTop">トップへ戻る</el-button>
    </el-empty>
  </div>
</template>

<script lang="ts">
import {defineComponent, useRouter} from '@nuxtjs/composition-api'

export default defineComponent({
  name: 'ErrorLayout',
  layout: 'plain',
  props: {
    error: {
      type: Object,
      default: null,
    },
  },
  setup(props) {
    const message = () => {
      switch (props.error.statusCode) {
        case 404:
          return 'ページが存在しません'
        default:
          return 'エラーが発生しました'
      }
    }
    const router = useRouter()
    const redirectToTop = () => {
      router.replace('/')
    }

    return {message, redirectToTop}
  },
  head(): object {
    return {
      title: this.message(),
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
