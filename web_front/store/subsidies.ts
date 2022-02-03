import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {Subsidy, SubsidiesResponse} from '@/types/Subsidy'

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
  itemsTotal: number = 0
  itemsPerPage: number = 0
  UserFavoriteSubsidy: number = 0

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

  @Mutation
  setItemsTotal(itemsTotal: number) {
    this.itemsTotal = itemsTotal
  }

  @Mutation
  setItemsPerPage(itemsPerPage: number) {
    this.itemsPerPage = itemsPerPage
  }

  @Action({rawError: true})
  async getSubsidies() {
    const res = await $axios.$get<SubsidiesResponse>('/subsidies')
    this.setSubsidies(res.subsidies)
    this.setCurrentPage(res.currentPage)
    this.setTotalPages(res.totalPages)
    this.setItemsTotal(res.itemsTotal)
    this.setItemsPerPage(res.itemsPerPage)
  }

  @Action({rawError: true})
  updateCurrentPage(page: number) {
    this.setCurrentPage(page)
    this.getSubsidies()
  }

  @Mutation
  setUserFavoriteSubsidy(UserFavoriteSubsidy: number) {
    this.UserFavoriteSubsidy = UserFavoriteSubsidy
  }

  @Action({rawError: true})
  async postUserFavoriteSubsidy(subsidyId: number) {
    await $axios.$post('/user_favorite_subsidies', {
      subsidyId,
    })
  }

  @Action({rawError: true})
  async getSubsidy(id: number) {
    const subsidy = await $axios.$get<Subsidy>(`/subsidies/${id}`)
    this.setSubsidy(subsidy)
  }
}
