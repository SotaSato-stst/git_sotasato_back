/* eslint-disable import/no-mutable-exports */
import {Store} from 'vuex'
import {getModule} from 'vuex-module-decorators'
import SubsidiesModule from '@/store/subsidies'
import SubsidyDraftModule from '@/store/subsidyDrafts'
import CompaniesModule from '@/store/companies'
import UsersModule from '@/store/users'
import OptionsModule from '~/store/options'

let subsidiesModule: SubsidiesModule
let subsidyDraftModule: SubsidyDraftModule
let companiesModule: CompaniesModule
let usersModule: UsersModule
let optionsModule: OptionsModule

function initialiseStores(store: Store<any>): void {
  subsidiesModule = getModule(SubsidiesModule, store)
  subsidyDraftModule = getModule(SubsidyDraftModule, store)
  companiesModule = getModule(CompaniesModule, store)
  usersModule = getModule(UsersModule, store)
  optionsModule = getModule(OptionsModule, store)
}

export {
  initialiseStores,
  subsidiesModule,
  subsidyDraftModule,
  companiesModule,
  usersModule,
  optionsModule,
}
