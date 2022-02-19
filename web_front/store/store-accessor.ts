/* eslint-disable import/no-mutable-exports */
import {Store} from 'vuex'
import {getModule} from 'vuex-module-decorators'
import SubsidiesModule from '@/store/subsidiesModule'
import FavoriteSubsidiesModule from '@/store/favoriteSubsidiesModule'
import RankingSubsidiesModule from '@/store/rankingSubsidiesModule'
import AccountModule from '@/store/accountModule'
import AdminSubsidiesModule from '@/store/adminSubsidiesModule'
import SubsidyDraftsModule from '@/store/subsidyDraftsModule'
import CompaniesModule from '@/store/companiesModule'
import UsersModule from '@/store/usersModule'
import OptionsModule from '@/store/optionsModule'

let subsidiesModule: SubsidiesModule
let favoriteSubsidiesModule: FavoriteSubsidiesModule
let rankingSubsidiesModule: RankingSubsidiesModule
let accountModule: AccountModule
let adminSubsidiesModule: AdminSubsidiesModule
let subsidyDraftsModule: SubsidyDraftsModule
let companiesModule: CompaniesModule
let usersModule: UsersModule
let optionsModule: OptionsModule

function initialiseStores(store: Store<any>): void {
  subsidiesModule = getModule(SubsidiesModule, store)
  favoriteSubsidiesModule = getModule(FavoriteSubsidiesModule, store)
  rankingSubsidiesModule = getModule(RankingSubsidiesModule, store)
  accountModule = getModule(AccountModule, store)
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
  rankingSubsidiesModule,
  accountModule,
  adminSubsidiesModule,
  subsidyDraftsModule,
  companiesModule,
  usersModule,
  optionsModule,
}
