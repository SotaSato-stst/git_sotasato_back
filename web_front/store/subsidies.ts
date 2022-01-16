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
  currentPage: number = 0
  totalPages: number = 0

  @Mutation
  setSubsidies(subsidies: Subsidy[]) {
    this.subsidies = subsidies
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
}
