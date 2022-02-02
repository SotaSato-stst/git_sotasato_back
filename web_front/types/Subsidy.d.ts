import {Ministry} from './Ministry'
import {Prefecture} from './Prefecture'
import {City} from './City'

export type SubsidyCategory = 'hojo' | 'josei'
export type SupplierType = 'ministry' | 'prefecture' | 'city'
export type PublishingCode = 'eiditing' | 'published'

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
}

export type SubsidiesResponse = {
  subsidies: Subsidy[]
  currentPage: number
  totalPages: number
  itemsTotal: number
  itemsPerPage: number
  prevPage: number
  nextPage: number
}

export type SubsidySearchParams = {
  prefectureIds: string // 1|2|3のような形
  cityIds: string // 1|2|3のような形
}
