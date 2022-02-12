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
import {filterUniqueObj} from '@/utils/arrayUtil'

@Module({
  name: 'subsidiesModule',
  stateFactory: true,
  namespaced: true,
})
export default class SubsidiesModule extends VuexModule {
  loader = useLoader()
  subsidies: Subsidy[] = []
  subsidy: Subsidy | null = null
  viewedSubsidies: Subsidy[] = []

  pagination: Pagination = {
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
  setSubsidy(subsidy: Subsidy | null) {
    this.subsidy = subsidy
  }

  @Mutation
  addViewedSubsidies(subsidy: Subsidy) {
    const subsidies = [subsidy].concat(this.viewedSubsidies)
    this.viewedSubsidies = filterUniqueObj(subsidies, 'id')
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
  async getSubsidy(id: number) {
    const subsidy = await $axios.$get<Subsidy>(`/subsidies/${id}`)
    this.setSubsidy(subsidy)
  }
}
