<template>
  <div class="container">
    <div class="list">
      <banner
        href="https://hojokin.or.jp/"
        src="https://hojokin.or.jp/wp-content/uploads/2022/01/logo_1_.png"
      />
      <banner
        href="https://hojokin.or.jp/?page_id=500"
        src="https://hojokin.or.jp/wp-content/uploads/2021/09/last_slider04.jpg"
      />
      <banner
        href="https://hojokin.or.jp/?page_id=836"
        src="https://hojokin.or.jp/wp-content/uploads/2021/08/last_slider03.jpg"
      />
    </div>
  </div>
</template>

<script lang="ts">
import {defineComponent} from '@nuxtjs/composition-api'
import {getAnalytics, logEvent} from 'firebase/analytics'
import Banner from '@/components/banners/Banner.vue'

export default defineComponent({
  name: 'SideRightMenu',
  components: {
    Banner,
  },
  setup(_props) {
    const analytics = getAnalytics()
    const clickedAskButton = () => {
      logEvent(analytics, 'click_ask_button')
      window.open(
        'https://costcut.co.jp/%e3%81%8a%e5%95%8f%e3%81%84%e5%90%88%e3%82%8f%e3%81%9b/',
      )
    }

    return {clickedAskButton}
  },
})
</script>

<style lang="postcss" scoped>
.container {
  padding-right: var(--spacing-4);
}

.list > * {
  margin: var(--spacing-5) 0;
}
</style>
