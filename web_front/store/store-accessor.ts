/* eslint-disable import/no-mutable-exports */
import {Store} from 'vuex'
import {getModule} from 'vuex-module-decorators'
import SubsidiesModule from '@/store/subsidies'
import FavoriteSubsidiesModule from '@/store/favoriteSubsidies'
import AdminSubsidiesModule from '~/store/adminSubsidies'
import SubsidyDraftsModule from '~/store/subsidyDrafts'
import CompaniesModule from '@/store/companies'
import UsersModule from '@/store/users'
import OptionsModule from '~/store/options'

let subsidiesModule: SubsidiesModule
let favoriteSubsidiesModule: FavoriteSubsidiesModule
let adminSubsidiesModule: AdminSubsidiesModule
let subsidyDraftsModule: SubsidyDraftsModule
let companiesModule: CompaniesModule
let usersModule: UsersModule
let optionsModule: OptionsModule

function initialiseStores(store: Store<any>): void {
  subsidiesModule = getModule(SubsidiesModule, store)
  favoriteSubsidiesModule = getModule(FavoriteSubsidiesModule, store)
  adminSubsidiesModule = getModule(AdminSubsidiesModule, store)
  subsidyDraftsModule = getModule(SubsidyDraftsModule, store)
  companiesModule = getModule(CompaniesModule, store)
  usersModule = getModule(UsersModule, store)
  optionsModule = getModule(OptionsModule, store)
}

export {
  initialiseStores,
  subsidiesModule,
  favoriteSubsidiesModule,
  adminSubsidiesModule,
  subsidyDraftsModule,
  companiesModule,
  usersModule,
  optionsModule,
}
