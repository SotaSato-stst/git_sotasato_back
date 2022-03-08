<template>
  <el-button
    class="inquiry-button"
    type="success"
    size="mini"
    icon="el-icon-user"
    @click="clickedAskButton()"
  >
    この補助金の申請を相談する
  </el-button>
</template>

<script lang="ts">
import {defineComponent, PropType} from '@nuxtjs/composition-api'
import {getAnalytics, logEvent} from 'firebase/analytics'
import {Subsidy} from '@/types/Subsidy'

export default defineComponent({
  name: 'InquiryButton',
  props: {
    subsidy: {
      type: Object as PropType<Subsidy>,
      required: true,
    },
  },
  setup(props) {
    const analytics = getAnalytics()
    const clickedAskButton = () => {
      logEvent(analytics, 'click_ask_button', {
        content_type: 'subsidy',
        content_id: props.subsidy.id,
        subsidy_title: props.subsidy.title,
      })
      window.open(
        'https://costcut.co.jp/%e3%81%8a%e5%95%8f%e3%81%84%e5%90%88%e3%82%8f%e3%81%9b/',
      )
    }

    return {clickedAskButton}
  },
})
</script>

<style lang="postcss" scoped>
.inquiry-button {
  background-color: #358f80;
  border-color: #358f80;
}
</style>
