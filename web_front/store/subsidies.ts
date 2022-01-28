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
  // @Action({rawError: true})
  // getSubsidy(id: number) {
  //   const subsidy: Subsidy = {
  //     id,
  //     title: 'Test',
  //     url: 'https://test.com',
  //     startFrom: new Date(2021, 4, 24),
  //     endTo: new Date(2021, 4, 27),
  //     publishingCode: 'published',
  //     priceMax: 1203330000,
  //     supportRatioMin: '20',
  //     supportRatioMax: '80',
  //     level: 3,
  //     detail: 'ものづくりする補助金です。',
  //     targetDetail: '製造業',
  //     subsidyCategory: 'hojo',
  //     supplierType: 'city',
  //   }
  //   this.setSubsidy(subsidy)
  // }
}
