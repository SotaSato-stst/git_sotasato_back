import {Ministry} from './Ministry'
import {Prefecture} from './Prefecture'
import {City} from './City'
import {Pagination} from './Pagination'
import {SupplierType} from './Subsidy'
import {User} from './User'

export type SubsidyDraft = {
  id: number
  title: string
  url: string
  ministry: Ministry | null
  prefecture: Prefecture | null
  city: City | null
  supplierType: SupplierType
  archived: boolean
  createdAt: Date
  assignee: User | null
  subsidyId: number | null
}

export type SubsidyDraftsResponse = {
  subsidyDrafts: SubsidyDraft[]
  pagination: Pagination
  completedCount: number
}

export type UpdateSubsidyDraftAssigneesResponse = {
  assignCount: number
}

export type SubsidyDraftAssignee = {
  userId: number
  userName: string
  assignCount: number
  completedCount: number
}

export type SubsidyDraftAssigneesResponse = {
  subsidyDraftTotal: number
  noAssignTotal: number
  completedTotal: number
  assignees: SubsidyDraftAssignee[]
}

export type FilterAssignType = 'assignedMe' | 'noAssign' | 'all'
export type FilterCompleteType = 'completed' | 'notCompleted' | 'all'

export type SubsidyDraftIndexParams = {
  page?: number
  assignFilter: FilterAssignType
  completeFilter: FilterCompleteType
}

export type UpdateSubsidyDraftParams = {
  id: number
  archive: boolean
}
