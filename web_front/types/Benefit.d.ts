import {Prefecture} from './Prefecture'
import {City} from './City'
import {Pagination} from './Pagination'

export type PublishingCode = 'editing' | 'published' | 'archived'

export type Benefit = {
  id: number
  title: string
  url: string
  endDate: string | null
  publishingCode: PublishingCode
  targetDetail: string
  priceDetail: string
  applicationDetail: string
  prefecture: Prefecture | null
  city: City | null
  forWelfare: boolean
  forElderlyCare: boolean
  forWidow: boolean
  forDisabled: boolean
  ageFrom: number | null
  ageTo: number | null
  householdIncomeFrom: number | null
  householdIncomeTo: number | null
}

export type BenefitsResponse = {
  benefits: Benefit[]
  pagination: Pagination
}

export type UpdateBenefitParams = {
  title: string
  url: string
  endDate: string | null
  publishingCode: PublishingCode
  targetDetail: string
  priceDetail: string
  applicationDetail: string
  prefectureId: number | null
  cityId: number | null
  forWelfare: boolean
  forElderlyCare: boolean
  forWidow: boolean
  forDisabled: boolean
  ageFrom: number | null
  ageTo: number | null
  householdIncomeFrom: number | null
  householdIncomeTo: number | null
}

export type FilterPublishingType = 'published' | 'editing' | 'archived' | 'all'
export type PublishingCodeOption = {
  label: FilterPublishingType
  text: string
}

export type SortBenefitType = 'end' | 'all'
export type SortBenefitOption = {
  label: string
  value: SortBenefitType
}

export type AdminBenefitIndexParams = {
  page?: number
  publishingCode: FilterPublishingType
  endAfter: string | null
  keyword: string | null
  sortingCode: SortBenefitType
}
