import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {
  Subsidy,
  SubsidiesResponse,
  SubsidySearchQuery,
  SubsidySearchForm,
} from '@/types/Subsidy'
import {Pagination} from '@/types/Pagination'
import {useLoader} from '@/services/useLoader'
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
    inApplicationPeriod: true,
    businessCategoryKeys: '',
    totalEmployee: null,
    capital: null,
    keyword: '',
    foundingDate: null,
    annualSales: null,
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
  setSearchParams(state: SubsidySearchForm) {
    this.searchParams = {
      prefectureId: state.prefectureId?.toString() || null,
      cityIds: state.cityIds?.join('|') || null,
      inApplicationPeriod: state.inApplicationPeriod,
      businessCategoryKeys: state.businessCategoryKeys?.join('|') || null,
      totalEmployee: state.totalEmployee || null,
      capital: state.capital || null,
      keyword: state.keyword,
      foundingDate: state.foundingDate || null,
      annualSales: state.annualSales || null,
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

  @Action({rawError: true})
  async getSubsidyPreview(id: number) {
    const subsidy = await $axios.$get<Subsidy>(`/subsidies/${id}/preview`)
    this.setSubsidy(subsidy)
  }
}
