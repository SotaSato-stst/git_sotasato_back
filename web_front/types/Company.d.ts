import {Prefecture} from './Prefecture'
import {City} from './City'
import {BusiessCategory} from './BusiessCategory'
import {Pagination} from './Pagination'

export type Company = {
  id: number
  name: string
  adress: string | null
  capital: number | null
  totalEmployee: number | null
  businessCategories: BusiessCategory[]
  prefecture: Prefecture
  city: City
  foundingDate: Date | null
  annualSales: number | null
}

export type CompaniesResponse = {
  companies: Company[]
  pagination: Pagination
}

export type CompanyParams = {
  name: string
  adress: string
  capital: number | null
  totalEmployee: number | null
  prefectureId: number | null
  cityId: number | null
  businessCategories: string[]
  foundingDate: string | null
  annualSales: number | null
}

export type CurrentCompany = {
  name: string
  adress: string
  capital: number
  totalEmployee: number
  businessCategories: string[]
  prefectureId: number
  cityId: number
  foundingDate: Date
  annualSales: number
}
