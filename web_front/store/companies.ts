import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {Company, CompaniesResponse, CompanyParams} from '@/types/Company'
import {Pagination} from '@/types/Pagination'

@Module({
  name: 'companies',
  stateFactory: true,
  namespaced: true,
})
export default class CompaniesModule extends VuexModule {
  companies: Company[] = []
  company: Company | null = null
  pagination: Pagination = {
    currentPage: 0,
    totalPages: 0,
    itemsTotal: 0,
    itemsPerPage: 0,
  }

  companyParams: CompanyParams = {
    name: '',
    adress: '',
    capital: null,
    totalEmployee: null,
    prefectureId: null,
    cityId: null,
    businessCategories: [],
  }

  @Mutation
  setCompanies(companies: Company[]) {
    this.companies = companies
  }

  @Mutation
  setCompany(company: Company) {
    this.company = company
    this.companyParams = {
      name: company.name,
      adress: company.adress,
      capital: company.capital,
      totalEmployee: company.totalEmployee,
      prefectureId: company.prefecture.id,
      cityId: company.city.id,
      businessCategories: company.businessCategories.map(c => c.key),
    }
  }

  @Mutation
  setPagination(pagination: Pagination) {
    this.pagination = pagination
  }

  @Mutation
  setCompanyParams(companyParams: CompanyParams) {
    this.companyParams = companyParams
  }

  @Action({rawError: true})
  async getCompanies(page?: number) {
    const res = await $axios.$get<CompaniesResponse>('/admin/companies', {
      params: {page: page || 1},
    })
    this.setCompanies(res.companies)
    this.setPagination(res.pagination)
  }

  @Action({rawError: true})
  async getCompany(id: number) {
    const company = await $axios.$get<Company>(`/admin/companies/${id}`)
    this.setCompany(company)
  }

  @Action({rawError: true})
  async postCompany() {
    const company = await $axios.$post<Company>(
      '/admin/companies',
      this.companyParams,
    )
    this.setCompany(company)
  }

  @Action({rawError: true})
  async putCompany(companyId: number) {
    const company = await $axios.$put<Company>(
      `/admin/companies/${companyId}`,
      this.companyParams,
    )
    this.setCompany(company)
  }
}
