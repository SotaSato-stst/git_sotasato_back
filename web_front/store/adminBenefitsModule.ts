import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {
  BenefitsResponse,
  Benefit,
  UpdateBenefitParams,
  AdminBenefitIndexParams,
} from '@/types/Benefit'
import {Pagination} from '@/types/Pagination'
import {useLoader} from '@/services/useLoader'

@Module({
  name: 'adminBenefitsModule',
  stateFactory: true,
  namespaced: true,
})
export default class AdminBenefitsModule extends VuexModule {
  loader = useLoader()
  benefits: Benefit[] = []
  benefit: Benefit | null = null
  pagination: Pagination = {
    currentPage: 0,
    totalPages: 0,
    itemsTotal: 0,
    itemsPerPage: 0,
  }

  @Mutation
  setBenefits(benefits: Benefit[]) {
    this.benefits = benefits
  }

  @Mutation
  setBenefit(benefit: Benefit | null) {
    this.benefit = benefit
  }

  @Mutation
  setPagination(pagination: Pagination) {
    this.pagination = pagination
  }

  @Action({rawError: true})
  async getBenefits(params: AdminBenefitIndexParams) {
    const res = await $axios.$get<BenefitsResponse>('/admin/benefits', {
      params: {
        page: params.page || 1,
        publishingCode: params.publishingCode,
        endAfter: params.endAfter,
        keyword: params.keyword,
        sortingCode: params.sortingCode,
      },
    })
    this.setBenefits(res.benefits)
    this.setPagination(res.pagination)
  }

  @Action({rawError: true})
  async getBenefit(id: number) {
    const benefit = await $axios.$get<Benefit>(`/admin/benefits/${id}`)
    this.setBenefit(benefit)
  }

  @Action({rawError: true})
  async postBenefit(params: UpdateBenefitParams): Promise<number> {
    const res = await $axios.$post<Benefit>('/admin/benefits', params)
    return res.id
  }

  @Action({rawError: true})
  async putBenefit(params: UpdateBenefitParams): Promise<number> {
    if (!this.benefit) {
      return Promise.reject(new Error('benefit not found'))
    }
    const res = await $axios.$put<Benefit>(
      `/admin/benefits/${this.benefit.id}`,
      params,
    )
    return res.id
  }
}
