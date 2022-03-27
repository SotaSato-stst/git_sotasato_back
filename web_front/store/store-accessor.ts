/* eslint-disable import/no-mutable-exports */
import {Store} from 'vuex'
import {getModule} from 'vuex-module-decorators'
import SubsidiesModule from '@/store/subsidiesModule'
import FavoriteSubsidiesModule from '@/store/favoriteSubsidiesModule'
import RankingSubsidiesModule from '@/store/rankingSubsidiesModule'
import AccountModule from '@/store/accountModule'
import AdminSubsidiesModule from '@/store/adminSubsidiesModule'
import SubsidyDraftsModule from '@/store/subsidyDraftsModule'
import AdminBenefitsModule from '@/store/adminBenefitsModule'
import CompaniesModule from '@/store/companiesModule'
import UsersModule from '@/store/usersModule'
import OptionsModule from '@/store/optionsModule'
import KeywordsModule from '@/store/keywordsModule'

let subsidiesModule: SubsidiesModule
let favoriteSubsidiesModule: FavoriteSubsidiesModule
let rankingSubsidiesModule: RankingSubsidiesModule
let accountModule: AccountModule
let adminSubsidiesModule: AdminSubsidiesModule
let subsidyDraftsModule: SubsidyDraftsModule
let adminBenefitsModule: AdminBenefitsModule
let companiesModule: CompaniesModule
let usersModule: UsersModule
let optionsModule: OptionsModule
let keywordsModule: KeywordsModule

function initialiseStores(store: Store<any>): void {
  subsidiesModule = getModule(SubsidiesModule, store)
  favoriteSubsidiesModule = getModule(FavoriteSubsidiesModule, store)
  rankingSubsidiesModule = getModule(RankingSubsidiesModule, store)
  accountModule = getModule(AccountModule, store)
  adminSubsidiesModule = getModule(AdminSubsidiesModule, store)
  subsidyDraftsModule = getModule(SubsidyDraftsModule, store)
  adminBenefitsModule = getModule(AdminBenefitsModule, store)
  companiesModule = getModule(CompaniesModule, store)
  usersModule = getModule(UsersModule, store)
  optionsModule = getModule(OptionsModule, store)
  keywordsModule = getModule(KeywordsModule, store)
}

export {
  initialiseStores,
  subsidiesModule,
  favoriteSubsidiesModule,
  rankingSubsidiesModule,
  accountModule,
  adminSubsidiesModule,
  subsidyDraftsModule,
  adminBenefitsModule,
  companiesModule,
  usersModule,
  optionsModule,
  keywordsModule,
}
