<template>
  <div class="container">
    <div class="title">最近の閲覧</div>
    <div v-for="subsidy in subsidies" :key="subsidy.id">
      <mini-subsidy-card :subsidy="subsidy" />
    </div>
    <div v-if="subsidies.length === 0">まだ閲覧がありません</div>
  </div>
</template>
<script lang="ts">
import {computed, defineComponent} from '@nuxtjs/composition-api'
import MiniSubsidyCard from '@/components/subsidies/MiniSubsidyCard.vue'
import {subsidiesModule} from '@/store'

export default defineComponent({
  components: {MiniSubsidyCard},
  setup(_props) {
    const subsidies = computed(() => subsidiesModule.viewedSubsidies)

    return {subsidies}
  },
})
</script>
<style lang="postcss" scoped>
.container {
  padding: var(--spacing-4);
  background-color: white;
  overflow: scroll;
  height: 100%;
}

.container > * {
  margin-bottom: var(--spacing-4);
}

.title {
  font-size: 14px;
  font-weight: bold;
}
</style>
