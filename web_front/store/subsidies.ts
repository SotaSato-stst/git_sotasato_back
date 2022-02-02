import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {Subsidy, SubsidiesResponse, SubsidySearchParams} from '@/types/Subsidy'
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
  pagination: Pagination = {
    currentPage: 0,
    totalPages: 0,
    itemsTotal: 0,
    itemsPerPage: 0,
  }

  searchParams: SubsidySearchParams = {
    prefectureIds: '',
    cityIds: '',
  }

  @Mutation
  setSubsidies(subsidies: Subsidy[]) {
    this.subsidies = subsidies
  }

  @Mutation
  setSubsidy(subsidy: Subsidy) {
    this.subsidy = subsidy
  }

  @Mutation
  setSearchParams(searchParams: SubsidySearchParams) {
    this.searchParams = searchParams
  }

  @Mutation
  setPagination(pagination: Pagination) {
    this.pagination = pagination
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

  // TODO:ikegaki APIでサーバーからsubsidyを取得するように変更
  @Action({rawError: true})
  async getSubsidy(id: number) {
    const subsidy = await $axios.$get<Subsidy>(`/subsidies/${id}`)
    this.setSubsidy(subsidy)
  }
}
