import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {SubsidyDraft, SubsidyDraftsResponse} from '@/types/SubsidyDraft'
import {Subsidy, UpdateSubsidyParams} from '@/types/Subsidy'
import {Pagination} from '@/types/Pagination'
import {useLoader} from '~/services/useLoader'

@Module({
  name: 'subsidyDrafts',
  stateFactory: true,
  namespaced: true,
})
export default class SubsidyDraftsModule extends VuexModule {
  loader = useLoader()
  subsidyDrafts: SubsidyDraft[] = []
  selectedSubsidyDrafts: SubsidyDraft[] = []
  subsidyDraft: SubsidyDraft | null = null

  pagination: Pagination = {
    currentPage: 0,
    totalPages: 0,
    itemsTotal: 0,
    itemsPerPage: 0,
  }

  @Mutation
  setSubsidyDrafts(subsidyDrafts: SubsidyDraft[]) {
    this.subsidyDrafts = subsidyDrafts
  }

  @Mutation
  setSelectedSubsidyDrafts(selectedSubsidyDrafts: SubsidyDraft[]) {
    this.selectedSubsidyDrafts = selectedSubsidyDrafts
  }

  @Mutation
  setSubsidyDraft(subsidyDraft: SubsidyDraft | null) {
    this.subsidyDraft = subsidyDraft
  }

  @Mutation
  setPagination(pagination: Pagination) {
    this.pagination = pagination
  }

  @Action({rawError: true})
  async getSubsidyDrafts(page?: number) {
    const res = await $axios.$get<SubsidyDraftsResponse>(
      '/admin/subsidy_drafts',
      {params: {page: page || 1}},
    )
    this.setSubsidyDrafts(res.subsidyDrafts)
    this.setPagination(res.pagination)
  }

  @Action({rawError: true})
  async getSubsidyDraft(id: number) {
    const subsidyDraft = await $axios.$get<SubsidyDraft>(
      `/admin/subsidy_drafts/${id}`,
    )
    this.setSubsidyDraft(subsidyDraft)
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
}
