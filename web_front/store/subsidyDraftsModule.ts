import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {
  SubsidyDraft,
  SubsidyDraftsResponse,
  SubsidyDraftAssignee,
  SubsidyDraftAssigneesResponse,
  UpdateSubsidyDraftAssigneesResponse,
  SubsidyDraftIndexParams,
  UpdateSubsidyDraftParams,
  BulkUpdateSubsidyDraftForBenefit,
  SubsidyDraftAssignStat,
} from '@/types/SubsidyDraft'
import {Subsidy, UpdateSubsidyParams} from '@/types/Subsidy'
import {Pagination} from '@/types/Pagination'
import {useLoader} from '@/services/useLoader'

type AssignParams = {
  assigneeId: number
  assignCount: number
}

@Module({
  name: 'subsidyDraftsModule',
  stateFactory: true,
  namespaced: true,
})
export default class SubsidyDraftsModule extends VuexModule {
  loader = useLoader()
  subsidyDrafts: SubsidyDraft[] = []
  assignees: SubsidyDraftAssignee[] = []
  assignStat: SubsidyDraftAssignStat | null = null
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
  setSubsidyDraftAssignees(assignees: SubsidyDraftAssignee[]) {
    this.assignees = assignees
  }

  @Mutation
  setAssignStat(assignStat: SubsidyDraftAssignStat) {
    this.assignStat = assignStat
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
  async getSubsidyDrafts(params: SubsidyDraftIndexParams) {
    const res = await $axios.$get<SubsidyDraftsResponse>(
      '/admin/subsidy_drafts',
      {
        params: {
          page: params.page || 1,
          assignFilter: params.assignFilter,
          completeFilter: params.completeFilter,
          benefitFilter: params.benefitFilter,
          keyword: params.keyword,
        },
      },
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
  async updateSubsidyDraft(params: UpdateSubsidyDraftParams) {
    await $axios.$put(`/admin/subsidy_drafts/${params.id}`, {
      archived: params.archive,
    })
  }

  @Action({rawError: true})
  async bulkArchive(ids: number[]) {
    await $axios.$post('/admin/subsidy_drafts/bulk_archive', {ids})
  }

  @Action({rawError: true})
  async bulkUpdateForBenefit(params: BulkUpdateSubsidyDraftForBenefit) {
    await $axios.$post('/admin/subsidy_drafts/bulk_update_for_benefit', params)
  }

  @Action({rawError: true})
  async postSubsidy(params: UpdateSubsidyParams): Promise<number> {
    const res = await $axios.$post<Subsidy>('/admin/subsidies', params)
    return res.id
  }

  @Action({rawError: true})
  async getNewSubsidy(date: string) {
    await $axios.$get('/admin/new_subsidy', {params: {date}})
  }

  @Action({rawError: true})
  async getAssignees() {
    const res = await $axios.$get<SubsidyDraftAssigneesResponse>(
      '/admin/subsidy_drafts_assignees',
    )
    this.setSubsidyDraftAssignees(res.assignees)
    this.setAssignStat(res.assignStat)
  }

  @Action({rawError: true})
  async putAssignee(params: AssignParams): Promise<number> {
    const res = await $axios.$put<UpdateSubsidyDraftAssigneesResponse>(
      `/admin/subsidy_drafts_assignees/${params.assigneeId}`,
      {assignCount: params.assignCount},
    )
    return res.assignCount
  }

  @Action({rawError: true})
  async deleteAssignee(params: AssignParams): Promise<number> {
    const res = await $axios.$delete<UpdateSubsidyDraftAssigneesResponse>(
      `/admin/subsidy_drafts_assignees/${params.assigneeId}?assign_count=${params.assignCount}`,
    )
    return res.assignCount
  }
}
