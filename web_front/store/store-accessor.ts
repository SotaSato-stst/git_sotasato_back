/* eslint-disable import/no-mutable-exports */
import {Store} from 'vuex'
import {getModule} from 'vuex-module-decorators'
import SubsidiesModule from '@/store/subsidies'
import CompaniesModule from '@/store/companies'
import OptionsModule from '~/store/options'

let subsidiesModule: SubsidiesModule
let companiesModule: CompaniesModule
let optionsModule: OptionsModule

function initialiseStores(store: Store<any>): void {
  subsidiesModule = getModule(SubsidiesModule, store)
  companiesModule = getModule(CompaniesModule, store)
  optionsModule = getModule(OptionsModule, store)
}

export {initialiseStores, subsidiesModule, companiesModule, optionsModule}
