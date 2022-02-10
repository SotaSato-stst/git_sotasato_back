import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {Company, CompaniesResponse, CompanyParams} from '@/types/Company'
import {Pagination} from '@/types/Pagination'
import {useLoader} from '@/services/useLoader'

@Module({
  name: 'companies',
  stateFactory: true,
  namespaced: true,
})
export default class CompaniesModule extends VuexModule {
  loader = useLoader()
  companies: Company[] = []
  company: Company | null = null
  pagination: Pagination = {
    currentPage: 0,
    totalPages: 0,
    itemsTotal: 0,
    itemsPerPage: 0,
  }

  @Mutation
  setCompanies(companies: Company[]) {
    this.companies = companies
  }

  @Mutation
  setCompany(company: Company | null) {
    this.company = company
  }

  @Mutation
  setPagination(pagination: Pagination) {
    this.pagination = pagination
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
  async postCompany(params: CompanyParams) {
    const company = await $axios.$post<Company>('/admin/companies', params)
    this.setCompany(company)
  }

  @Action({rawError: true})
  async putCompany(params: CompanyParams) {
    const company = await $axios.$put<Company>(
      `/admin/companies/${this.company!.id}`,
      params,
    )
    this.setCompany(company)
  }
}
