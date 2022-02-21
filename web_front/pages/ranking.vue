<template>
  <el-container class="center-container">
    <el-aside class="left-side-menu" width="var(--header-width)">
      <search-menu />
    </el-aside>
    <el-main>
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
            class="ranking-title"
            :style="`border-color: ${
              rankingColors[index] || 'var(--text-color)'
            }`"
          >
            <icon-crown
              v-if="index < rankingColors.length"
              :size="24"
              :color="rankingColors[index]"
            />
            <div>第{{ index + 1 }}位</div>
            <div>「{{ subsidy.title }}」</div>
          </el-tag>
          <subsidy-card v-if="!loading" :subsidy="subsidy" />
        </div>
        <el-empty
          v-if="!loading && rankings.length == 0"
          description="データがありません"
        />
      </div>
    </el-main>
    <el-aside width="316px">
      <side-right-menu />
    </el-aside>
  </el-container>
</template>

<script lang="ts">
import {computed, defineComponent, onMounted} from '@nuxtjs/composition-api'
import {Container, Aside, Main, Empty} from 'element-ui'
import SearchMenu from '@/components/subsidies/SearchMenu.vue'
import SideRightMenu from '@/components/layouts/SideRightMenu.vue'
import CardLoading from '@/components/CardLoading.vue'
import SubsidyCard from '@/components/subsidies/SubsidyCard.vue'
import IconCrown from '@/components/icons/IconCrown.vue'
import {rankingSubsidiesModule} from '@/store'

export default defineComponent({
  name: 'RankingPage',
  components: {
    [`${Container.name}`]: Container,
    [`${Aside.name}`]: Aside,
    [`${Main.name}`]: Main,
    [`${Empty.name}`]: Empty,
    SearchMenu,
    SideRightMenu,
    SubsidyCard,
    CardLoading,
    IconCrown,
  },
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
.container > * {
  margin-bottom: var(--spacing-4);
}

.left-side-menu {
  background-color: white;
  width: 100%;
  height: 100%;
}

.title {
  font-size: 21px;
  font-weight: bold;
}

.ranking-title {
  font-weight: bold;
  font-size: 16px;
  color: var(--text-color);
  display: flex;
  align-items: center;
  width: fit-content;
  height: fit-content;
  margin-bottom: var(--spacing-4);
}

.ranking-title > * {
  margin-right: var(--spacing-4);
}

.subsidy-card:nth-child(n + 2) {
  margin-top: var(--spacing-8);
}
</style>
