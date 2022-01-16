/* eslint-disable import/no-mutable-exports */
import {Store} from 'vuex'
import {getModule} from 'vuex-module-decorators'
import SubsidiesModule from '@/store/subsidies'

let subsidiesModule: SubsidiesModule

function initialiseStores(store: Store<any>): void {
  subsidiesModule = getModule(SubsidiesModule, store)
}

export {initialiseStores, subsidiesModule}
