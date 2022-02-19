import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {Subsidy, SubsidiesResponse} from '@/types/Subsidy'
import {useLoader} from '@/services/useLoader'

@Module({
  name: 'rankingSubsidiesModule',
  stateFactory: true,
  namespaced: true,
})
export default class RankingSubsidiesModule extends VuexModule {
  loader = useLoader()
  rankingSubsidies: Subsidy[] = []

  @Mutation
  setRankingSubsidies(rankingSubsidies: Subsidy[]) {
    this.rankingSubsidies = rankingSubsidies
  }

  @Action({rawError: true})
  async getRankingSubsidies() {
    const res = await $axios.$get<SubsidiesResponse>('/ranking_subsidies')
    this.setRankingSubsidies(res.subsidies)
  }
}
