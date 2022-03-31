import {Ministry} from './Ministry'
import {Prefecture} from './Prefecture'
import {City} from './City'
import {Pagination} from './Pagination'
import {BusiessCategory} from './BusiessCategory'
import {OrganizationType} from './OrganizationType'

export type SubsidyCategory = 'hojo' | 'josei' | 'kyufu'
export type SupplierType = 'ministry' | 'prefecture' | 'city'
export type PublishingCode = 'editing' | 'published' | 'archived'

export type Subsidy = {
  id: number
  title: string
  url: string
  startFrom: string | null
  endTo: string | null
  publishingCode: PublishingCode
  priceMax: number | null
  supportRatioMin: string | null
  supportRatioMax: string | null
  level: number | null
  detail: string
  subsidyCategory: SubsidyCategory
  supplierType: SupplierType
  ministry: Ministry | null
  prefecture: Prefecture | null
  city: City | null
  organizationTypes: OrganizationType[]
  businessCategories: BusiessCategory[]
  keywords: string[]
  favorite: boolean
  rankingScore: number | null
  capitalMax: number | null
  capitalMin: number | null
  totalEmployeeMax: number | null
  totalEmployeeMin: number | null
  yearsOfEstablishment: number | null
  annualSalesMax: number | null
  annualSalesMin: number | null
  catchCopy: string | null
}

export type SubsidiesResponse = {
  subsidies: Subsidy[]
  pagination: Pagination
}
// APIで投げるフォーマット
export type SubsidySearchQuery = {
  prefectureId: string | null
  cityId: string | null
  inApplicationPeriod: boolean
  organizationType: string | null
  businessCategories: string[]
  totalEmployee: number | null
  capital: number | null
  keyword: string
  foundingDate: string | null
  annualSales: number | null
}
// フォームで取り扱うフォーマット
export type SubsidySearchForm = {
  prefectureId: number | null
  cityId: number | null
  inApplicationPeriod: boolean
  organizationType: string | null
  businessCategories: string[]
  totalEmployee: number | null
  capital: number | null
  keyword: string
  foundingDate: Date | null
  annualSales: number | null
}

export type UpdateSubsidyParams = {
  title: string
  url: string
  publishingCode: PublishingCode
  subsidyCategory: SubsidyCategory
  startFrom: string | null
  endTo: string | null
  priceMax: number | null
  supportRatioMin: string | null
  supportRatioMax: string | null
  level: number | null
  detail: string
  ministryId: number | null
  prefectureId: number | null
  cityId: number | null
  supplierType: SupplierType
  organizationTypes: string[]
  businessCategories: string[]
  keywords: string
  rankingScore: number | null
  capitalMax: number | null
  capitalMin: number | null
  totalEmployeeMax: number | null
  totalEmployeeMin: number | null
  yearsOfEstablishment: number | null
  annualSalesMax: number | null
  annualSalesMin: number | null
  catchCopy: string | null
}

export type FilterPublishingType = 'published' | 'editing' | 'archived' | 'all'
export type PublishingCodeOption = {
  label: FilterPublishingType
  text: string
}

export type FilterSubsidyCategoryType = 'hojo' | 'josei' | 'kyufu' | 'all'
export type SubsidyCategoryOption = {
  label: string
  value: FilterSubsidyCategoryType
}

export type SortSubsidyType = 'price' | 'end' | 'all' | 'ranking'
export type SortSubsidyOption = {
  label: string
  value: SortSubsidyType
}

export type AdminSubsidyIndexParams = {
  page?: number
  publishingCode: FilterPublishingType
  endAfter: string | null
  keyword: string | null
  subsidyCategory: FilterSubsidyCategoryType
  sortingCode: SortSubsidyType
  ministryId: number | null
}
