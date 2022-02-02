import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {Company, CompaniesResponse, CompanyParams} from '@/types/Company'

@Module({
  name: 'companies',
  stateFactory: true,
  namespaced: true,
})
export default class CompaniesModule extends VuexModule {
  companies: Company[] = []
  company: Company | null = null
  currentPage: number = 0
  totalPages: number = 0
  itemsTotal: number = 0
  itemsPerPage: number = 0
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
  setCurrentPage(currentPage: number) {
    this.currentPage = currentPage
  }

  @Mutation
  setTotalPages(totalPages: number) {
    this.totalPages = totalPages
  }

  @Mutation
  setItemsTotal(itemsTotal: number) {
    this.itemsTotal = itemsTotal
  }

  @Mutation
  setItemsPerPage(itemsPerPage: number) {
    this.itemsPerPage = itemsPerPage
  }

  @Mutation
  setCompanyParams(companyParams: CompanyParams) {
    this.companyParams = companyParams
  }

  @Action({rawError: true})
  async getCompanies() {
    const res = await $axios.$get<CompaniesResponse>('/admin/companies')
    this.setCompanies(res.companies)
    this.setCurrentPage(res.currentPage)
    this.setTotalPages(res.totalPages)
    this.setItemsTotal(res.itemsTotal)
    this.setItemsPerPage(res.itemsPerPage)
  }

  @Action({rawError: true})
  updateCurrentPage(page: number) {
    this.setCurrentPage(page)
    this.getCompanies()
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
