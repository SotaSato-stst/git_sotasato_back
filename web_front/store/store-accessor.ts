/* eslint-disable import/no-mutable-exports */
import {Store} from 'vuex'
import {getModule} from 'vuex-module-decorators'
import SubsidiesModule from '@/store/subsidies'
import AdminSubsidiesModule from '~/store/adminSubsidies'
import CompaniesModule from '@/store/companies'
import UsersModule from '@/store/users'
import OptionsModule from '~/store/options'

let subsidiesModule: SubsidiesModule
let adminSubsidiesModule: AdminSubsidiesModule
let companiesModule: CompaniesModule
let usersModule: UsersModule
let optionsModule: OptionsModule

function initialiseStores(store: Store<any>): void {
  subsidiesModule = getModule(SubsidiesModule, store)
  adminSubsidiesModule = getModule(AdminSubsidiesModule, store)
  companiesModule = getModule(CompaniesModule, store)
  usersModule = getModule(UsersModule, store)
  optionsModule = getModule(OptionsModule, store)
}

export {
  initialiseStores,
  subsidiesModule,
  adminSubsidiesModule,
  companiesModule,
  usersModule,
  optionsModule,
}
