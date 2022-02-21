import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {useLoader} from '@/services/useLoader'
import {TopKeywords} from '@/types/Keyword'

@Module({
  name: 'keywordsModule',
  stateFactory: true,
  namespaced: true,
})
export default class OptionsModule extends VuexModule {
  loader = useLoader()
  topKeywords: string[] = []

  @Mutation
  setTopKeywords(topKeywords: string[]) {
    this.topKeywords = topKeywords
  }

  @Action({rawError: true})
  async getTopKeywords() {
    const res = await $axios.$get<TopKeywords>('/admin/top_keywords')
    this.setTopKeywords(res.keywords)
  }
}
