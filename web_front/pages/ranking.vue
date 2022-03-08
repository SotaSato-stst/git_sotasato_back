<template>
  <div class="container">
    <div class="title">おすすめの補助金・助成金ランキング</div>
    <card-loading :loading="loading" />
    <div
      v-for="(subsidy, index) in rankings"
      :key="subsidy.id"
      class="subsidy-card"
    >
      <el-tag
        v-if="!loading"
        effect="plain"
        class="ranking-tag"
        :style="`border-color: ${rankingColors[index] || 'var(--text-color)'}`"
      >
        <div>
          <icon-crown
            v-if="index < rankingColors.length"
            :size="24"
            :color="rankingColors[index]"
            class="crown"
          />
        </div>
        <div class="ranking-title">
          第{{ index + 1 }}位 「{{ subsidy.title }}」
        </div>
      </el-tag>
      <subsidy-card v-if="!loading" :subsidy="subsidy" />
    </div>
    <el-empty
      v-if="!loading && rankings.length == 0"
      description="データがありません"
    />
  </div>
</template>

<script lang="ts">
import {computed, defineComponent, onMounted} from '@nuxtjs/composition-api'
import CardLoading from '@/components/CardLoading.vue'
import SubsidyCard from '@/components/subsidies/SubsidyCard.vue'
import IconCrown from '@/components/icons/IconCrown.vue'
import {rankingSubsidiesModule} from '@/store'

export default defineComponent({
  name: 'RankingPage',
  components: {
    SubsidyCard,
    CardLoading,
    IconCrown,
  },
  layout: ctx => (ctx.$device.isMobile ? 'mobile' : 'recent'),
  setup(_props) {
    const {loading, load} = rankingSubsidiesModule.loader
    const rankings = computed(() => rankingSubsidiesModule.rankingSubsidies)
    const rankingColors = [
      'var(--color-gold)',
      'var(--color-silver)',
      'var(--color-bronze)',
    ]
    onMounted(() => {
      load(loading, () => {
        rankingSubsidiesModule.getRankingSubsidies()
      })
    })

    return {
      loading,
      rankings,
      rankingColors,
    }
  },
  head(): object {
    return {
      title: 'おすすめの補助金・助成金ランキング',
    }
  },
})
</script>

<style lang="postcss" scoped>
.container {
  padding: var(--spacing-5);
}

.container > * {
  margin-bottom: var(--spacing-4);
}

.left-side-menu {
  background-color: white;
  width: 100%;
  height: 100%;
}

.title {
  font-size: 22px;
  font-weight: bold;
}

.ranking-tag {
  font-weight: bold;
  font-size: 16px;
  color: var(--text-color);
  display: flex;
  align-items: center;
  width: fit-content;
  height: fit-content;
  margin-bottom: var(--spacing-4);
  max-width: 100%;
  overflow: hidden;
}

.ranking-title {
  word-break: break-all;
  max-width: calc(100% - 32px);
  overflow: hidden;
  text-overflow: ellipsis;
}

.crown {
  margin: 8px 8px 0 0;
  height: fit-content;
  width: fit-content;
}

.subsidy-card:nth-child(n + 2) {
  margin-top: var(--spacing-8);
}
</style>
