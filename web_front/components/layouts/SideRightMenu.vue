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
import Banner from '~/components/banners/Banner.vue'

export default defineComponent({
  name: 'SideRightMenu',
  components: {
    Banner,
  },
  setup(_props) {
    return {}
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
