import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {Prefecture, PrefectureResponse} from '@/types/Prefecture'
import {City, CityResponse} from '@/types/City'
import {BusiessCategory, BusiessCategoryResponse} from '@/types/BusiessCategory'

@Module({
  name: 'options',
  stateFactory: true,
  namespaced: true,
})
export default class OptionsModule extends VuexModule {
  prefectures: Prefecture[] = []
  cities: Prefecture[] = []
  businessCategories: BusiessCategory[] = []

  @Mutation
  setPrefectures(prefectures: Prefecture[]) {
    this.prefectures = prefectures
  }

  @Mutation
  setCities(cities: City[]) {
    this.cities = cities
  }

  @Mutation
  setBusinessCategories(businessCategories: BusiessCategory[]) {
    this.businessCategories = businessCategories
  }

  @Action({rawError: true})
  async getPrefectures() {
    const res = await $axios.$get<PrefectureResponse>('/prefectures')
    this.setPrefectures(res.prefectures)
  }

  @Action({rawError: true})
  async getCities(prefectureId: string) {
    const res = await $axios.$get<CityResponse>(
      `/prefectures/${prefectureId}/cities`,
    )
    this.setCities(res.cities)
  }

  @Action({rawError: true})
  async getBusinessCategories() {
    const res = await $axios.$get<BusiessCategoryResponse>(
      '/business_categories',
    )
    this.setBusinessCategories(res.businessCategories)
  }
}
