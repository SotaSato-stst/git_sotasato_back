import {Prefecture} from './Prefecture'
import {City} from './City'
import {BusiessCategory} from './BusiessCategory'

export type Company = {
  id: number
  name: string
  adress: string
  capital: number
  totalEmployee: number
  businessCategories: BusiessCategory[]
  prefecture: Prefecture
  city: City
}

export type CompaniesResponse = {
  companies: Company[]
  currentPage: number
  totalPages: number
  itemsTotal: number
  itemsPerPage: number
}

export type CompanyParams = {
  name: string
  adress: string
  capital: number | null
  totalEmployee: number | null
  prefectureId: number | null
  cityId: number | null
  businessCategories: string[]
}
