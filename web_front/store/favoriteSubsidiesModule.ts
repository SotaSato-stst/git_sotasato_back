import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {Subsidy, SubsidiesResponse} from '@/types/Subsidy'
import {Pagination} from '@/types/Pagination'
import {useLoader} from '@/services/useLoader'

@Module({
  name: 'favoriteSubsidiesModule',
  stateFactory: true,
  namespaced: true,
})
export default class FavoriteSubsidiesModule extends VuexModule {
  loader = useLoader()
  userFavoriteSubsidies: Subsidy[] = []
  pagination: Pagination = {
    currentPage: 0,
    totalPages: 0,
    itemsTotal: 0,
    itemsPerPage: 0,
  }

  @Mutation
  setUserFavoriteSubsidies(userFavoriteSubsidies: Subsidy[]) {
    this.userFavoriteSubsidies = userFavoriteSubsidies
  }

  @Mutation
  setPagination(pagination: Pagination) {
    this.pagination = pagination
  }

  @Action({rawError: true})
  async getUserFavoriteSubsidies(page?: number) {
    const res = await $axios.$get<SubsidiesResponse>(
      '/user_favorite_subsidies',
      {params: {page: page || 1}},
    )
    this.setUserFavoriteSubsidies(res.subsidies)
    this.setPagination(res.pagination)
  }

  @Action({rawError: true})
  async postUserFavoriteSubsidy(subsidyId: number) {
    await $axios.$post('/user_favorite_subsidies', {
      subsidyId,
    })
  }

  @Action({rawError: true})
  async destroyUserFavoriteSubsidy(subsidyId: number) {
    await $axios.$delete(`/user_favorite_subsidies/${subsidyId}`)
  }
}
