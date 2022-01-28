<template>
  <div class="container">
    <div v-for="subsidy in subsidies" :key="subsidy.id">
      <subsidy-card :subsidy="subsidy" />
    </div>
  </div>
</template>

<script lang="ts">
import {computed, defineComponent, onMounted} from '@vue/composition-api'
import SubsidyCard from './../components/SubsidyCard.vue'
import {subsidiesModule} from '~/store'

export default defineComponent({
  name: 'IndexPage',
  components: {SubsidyCard},
  setup(_props) {
    const subsidies = computed(() => subsidiesModule.subsidies)
    const currentPage = computed(() => subsidiesModule.currentPage)
    const totalPages = computed(() => subsidiesModule.totalPages)

    onMounted(() => {
      subsidiesModule.getSubsidies()
    })
    return {
      subsidies,
      currentPage,
      totalPages,
    }
  },
})
</script>

<style lang="postcss" scoped>
.container > * {
  margin-bottom: var(--spacing-4);
}
</style>
