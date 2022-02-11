import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {
  Subsidy,
  SubsidiesResponse,
  SubsidySearchQuery,
  SubsidySearchForm,
} from '@/types/Subsidy'
import {Pagination} from '@/types/Pagination'
import {useLoader} from '~/services/useLoader'

@Module({
  name: 'subsidies',
  stateFactory: true,
  namespaced: true,
})
export default class SubsidiesModule extends VuexModule {
  loader = useLoader()
  subsidies: Subsidy[] = []
  subsidy: Subsidy | null = null
  userFavoriteSubsidies: Subsidy[] = []
  pagination: Pagination = {
    currentPage: 0,
    totalPages: 0,
    itemsTotal: 0,
    itemsPerPage: 0,
  }

  favoritePagination: Pagination = {
    currentPage: 0,
    totalPages: 0,
    itemsTotal: 0,
    itemsPerPage: 0,
  }

  searchParams: SubsidySearchQuery = {
    prefectureId: null,
    cityIds: '',
  }

  @Mutation
  setSubsidies(subsidies: Subsidy[]) {
    this.subsidies = subsidies
  }

  @Mutation
  setUserFavoriteSubsidies(userFavoriteSubsidies: Subsidy[]) {
    this.userFavoriteSubsidies = userFavoriteSubsidies
  }

  @Mutation
  setSubsidy(subsidy: Subsidy | null) {
    this.subsidy = subsidy
  }

  @Mutation
  setSearchParams(form: SubsidySearchForm) {
    this.searchParams = {
      prefectureId: form.prefectureId?.toString() || null,
      cityIds: form.cityIds?.join('|') || null,
    }
  }

  @Mutation
  setPagination(pagination: Pagination) {
    this.pagination = pagination
  }

  @Mutation
  setFavoritePagination(favoritePagination: Pagination) {
    this.favoritePagination = favoritePagination
  }

  @Action({rawError: true})
  async getSubsidies(page?: number) {
    const res = await $axios.$get<SubsidiesResponse>('/subsidies', {
      params: {
        page: page || 1,
        ...this.searchParams,
      },
    })
    this.setSubsidies(res.subsidies)
    this.setPagination(res.pagination)
  }

  @Action({rawError: true})
  async getUserFavoriteSubsidies(page?: number) {
    const res = await $axios.$get<SubsidiesResponse>(
      '/user_favorite_subsidies',
      {params: {page: page || 1}},
    )
    this.setUserFavoriteSubsidies(res.subsidies)
    this.setFavoritePagination(res.pagination)
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

  @Action({rawError: true})
  async getSubsidy(id: number) {
    const subsidy = await $axios.$get<Subsidy>(`/subsidies/${id}`)
    this.setSubsidy(subsidy)
  }
}
