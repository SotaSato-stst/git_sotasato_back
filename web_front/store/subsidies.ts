import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '~/utils/api'
import {Subsidy, SubsidiesResponse} from '~/types/Subsidy'

@Module({
  name: 'subsidies',
  stateFactory: true,
  namespaced: true,
})
export default class SubsidiesModule extends VuexModule {
  subsidies: Subsidy[] = []
  subsidy: Subsidy | null = null
  currentPage: number = 0
  totalPages: number = 0

  @Mutation
  setSubsidies(subsidies: Subsidy[]) {
    this.subsidies = subsidies
  }

  @Mutation
  setSubsidy(subsidy: Subsidy) {
    this.subsidy = subsidy
  }

  @Mutation
  setCurrentPage(currentPage: number) {
    this.currentPage = currentPage
  }

  @Mutation
  setTotalPages(totalPages: number) {
    this.totalPages = totalPages
  }

  @Action({rawError: true})
  async getSubsidies() {
    const res = await $axios.$get<SubsidiesResponse>('/subsidies')
    this.setSubsidies(res.subsidies)
    this.setCurrentPage(res.currentPage)
    this.setTotalPages(res.totalPages)
  }

  @Action({rawError: true})
  updateCurrentPage(page: number) {
    this.setCurrentPage(page)
    this.getSubsidies()
  }

  // TODO:ikegaki APIでサーバーからsubsidyを取得するように変更
  @Action({rawError: true})
  getSubsidy(id: number) {
    const subsidy: Subsidy = {
      id,
      title: 'タイトル',
      url: 'https://google.com',
      startFrom: new Date(2022, 4, 1),
      endTo: new Date(2022, 5, 1),
      publishingCode: 'published',
      priceMax: 1000000,
      supportRatioMin: '1/2',
      supportRatioMax: '2/3',
      level: 4,
      detail: '詳細',
      targetDetail: '対象',
      subsidyCategory: 'hojo',
      supplierType: 'ministry',
      ministry: {
        id: 1,
        name: '経済産業省',
        logoUrl: '',
      },
      prefecture: null,
      city: null,
    }
    this.setSubsidy(subsidy)
  }
}
