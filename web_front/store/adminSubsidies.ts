import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {SubsidiesResponse, Subsidy, UpdateSubsidyParams} from '@/types/Subsidy'
import {Pagination} from '@/types/Pagination'
import {useLoader} from '~/services/useLoader'

@Module({
  name: 'adminSubsidies',
  stateFactory: true,
  namespaced: true,
})
export default class AdminSubsidiesModule extends VuexModule {
  loader = useLoader()
  subsidies: Subsidy[] = []
  subsidy: Subsidy | null = null
  pagination: Pagination = {
    currentPage: 0,
    totalPages: 0,
    itemsTotal: 0,
    itemsPerPage: 0,
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
  setPagination(pagination: Pagination) {
    this.pagination = pagination
  }

  @Action({rawError: true})
  async getSubsidies(page?: number) {
    const res = await $axios.$get<SubsidiesResponse>('/admin/subsidies', {
      params: {page: page || 1},
    })
    this.setSubsidies(res.subsidies)
    this.setPagination(res.pagination)
  }

  @Action({rawError: true})
  async getSubsidy(id: number) {
    const subsidy = await $axios.$get<Subsidy>(`/admin/subsidies/${id}`)
    this.setSubsidy(subsidy)
  }

  @Action({rawError: true})
  async deleteSubsidyDraft(id: number) {
    await $axios.$delete(`/admin/subsidy_drafts/${id}`)
  }

  @Action({rawError: true})
  async postSubsidy(params: UpdateSubsidyParams): Promise<number> {
    const res = await $axios.$post<Subsidy>('/admin/subsidies', params)
    return res.id
  }

  @Action({rawError: true})
  async putSubsidy(params: UpdateSubsidyParams): Promise<number> {
    if (!this.subsidy) {
      return Promise.reject(new Error('subsidy not found'))
    }
    const res = await $axios.$put<Subsidy>(
      `/admin/subsidies/${this.subsidy.id}`,
      params,
    )
    return res.id
  }
}
