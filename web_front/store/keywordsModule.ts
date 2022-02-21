import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {useLoader} from '@/services/useLoader'
import {TopKeywords, SearchedKeywords, SearchedKeyword} from '@/types/Keyword'

@Module({
  name: 'keywordsModule',
  stateFactory: true,
  namespaced: true,
})
export default class OptionsModule extends VuexModule {
  loader = useLoader()
  topKeywords: string[] = []
  searchedKeywords: SearchedKeyword[] = []

  @Mutation
  setTopKeywords(topKeywords: string[]) {
    this.topKeywords = topKeywords
  }

  @Mutation
  setSearchedKeywords(searchedKeywords: SearchedKeyword[]) {
    this.searchedKeywords = searchedKeywords
  }

  @Action({rawError: true})
  async getTopKeywords() {
    const res = await $axios.$get<TopKeywords>('/admin/top_keywords')
    this.setTopKeywords(res.keywords)
  }

  @Action({rawError: true})
  async getSearchedKeywords() {
    const res = await $axios.$get<SearchedKeywords>('/admin/searched_keywords')
    this.setSearchedKeywords(res.keywords)
  }
}
