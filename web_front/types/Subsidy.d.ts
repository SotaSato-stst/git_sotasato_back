import {Ministry} from './Ministry'
import {Prefecture} from './Prefecture'
import {City} from './City'
import {Pagination} from './Pagination'
import {BusiessCategory} from './BusiessCategory'

export type SubsidyCategory = 'hojo' | 'josei'
export type SupplierType = 'ministry' | 'prefecture' | 'city'
export type PublishingCode = 'editing' | 'published'

export type Subsidy = {
  id: number
  title: string
  url: string
  startFrom: Date
  endTo: Date | null
  publishingCode: PublishingCode
  priceMax: number | null
  supportRatioMin: string | null
  supportRatioMax: string | null
  level: number | null
  detail: string
  targetDetail: string
  subsidyCategory: SubsidyCategory
  supplierType: SupplierType
  ministry: Ministry | null
  prefecture: Prefecture | null
  city: City | null
  businessCategories: BusiessCategory[]
  favorite: boolean
  rankingScore: number | null
}

export type SubsidiesResponse = {
  subsidies: Subsidy[]
  pagination: Pagination
}
// APIで投げるフォーマット
export type SubsidySearchQuery = {
  prefectureId: string | null
  cityIds: string | null // 1|2|3のような形
  inApplicationPeriod: boolean
  businessCategoryKeys: string | null
}
// フォームで取り扱うフォーマット
export type SubsidySearchForm = {
  prefectureId: number | null
  cityIds: number[]
  inApplicationPeriod: boolean
  businessCategoryKeys: string[]
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
  targetDetail: string | null
  ministryId: number | null
  prefectureId: number | null
  cityId: number | null
  supplierType: SupplierType
  businessCategories: string[]
  rankingScore: number | null
}
