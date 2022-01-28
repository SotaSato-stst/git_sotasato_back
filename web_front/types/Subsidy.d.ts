import {Ministry} from './Ministry'
import {Prefecture} from './Prefecture'
import {City} from './City'

export type SubsidyCategory = 'hojo' | 'josei'
export type SupplierType = 'ministry' | 'prefecture' | 'city'

export type Subsidy = {
  id: number
  title: string
  url: string
  startFrom: Date
  endTo: Date
  publishingCode: string
  priceMax: number
  supportRatioMin: string
  supportRatioMax: string
  level: number
  detail: string
  targetDetail: string
  subsidyCategory: SubsidyCategory
  supplierType: SupplierType
  ministry: Ministry
  prefecture: Prefecture
  city: City
}

export type SubsidiesResponse = {
  subsidies: Subsidy[]
  currentPage: number
  totalPages: number
}
