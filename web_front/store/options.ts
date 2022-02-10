import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {Prefecture, PrefectureResponse} from '@/types/Prefecture'
import {City, CityResponse} from '@/types/City'
import {BusiessCategory, BusiessCategoryResponse} from '@/types/BusiessCategory'
import {Ministry, MinistryResponse} from '~/types/Ministry'
import {useLoader} from '@/services/useLoader'

@Module({
  name: 'options',
  stateFactory: true,
  namespaced: true,
})
export default class OptionsModule extends VuexModule {
  loader = useLoader()
  ministries: Ministry[] = []
  prefectures: Prefecture[] = []
  cities: Prefecture[] = []
  businessCategories: BusiessCategory[] = []

  @Mutation
  setMinistries(ministries: Ministry[]) {
    this.ministries = ministries
  }

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
  async getMinistries() {
    const res = await $axios.$get<MinistryResponse>('/ministries')
    this.setMinistries(res.ministries)
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
