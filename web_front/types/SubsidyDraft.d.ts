import {Ministry} from './Ministry'
import {Prefecture} from './Prefecture'
import {City} from './City'
import {Pagination} from './Pagination'
import {SupplierType} from './Subsidy'

export type SubsidyDraft = {
  id: number
  title: string
  url: string
  ministry: Ministry | null
  prefecture: Prefecture | null
  city: City | null
  supplierType: SupplierType
}

export type SubsidyDraftsResponse = {
  subsidyDrafts: SubsidyDraft[]
  pagination: Pagination
}
