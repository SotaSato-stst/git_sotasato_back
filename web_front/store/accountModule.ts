import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {UpdateCurrentUserParams, CurrentUser} from '@/types/User'
import {useLoader} from '@/services/useLoader'
import CookieStore from '@/services/cookieStore'

@Module({
  name: 'accountModule',
  stateFactory: true,
  namespaced: true,
})
export default class AccountModule extends VuexModule {
  loader = useLoader()
  currentUser: CurrentUser | null = null

  @Mutation
  setCurrentUser(currentUser: CurrentUser | null) {
    this.currentUser = currentUser
    if (currentUser && currentUser.accountRole !== 'user') {
      CookieStore.setAccountRole(currentUser.accountRole)
    }
  }

  @Action({rawError: true})
  async getCurrentUser() {
    const user = await $axios.$get<CurrentUser>('/current_user')
    this.setCurrentUser(user)
  }

  @Action({rawError: true})
  async putCurrentUser(params: UpdateCurrentUserParams) {
    const user = await $axios.$put<CurrentUser>('/current_user', {
      ...params,
    })
    this.setCurrentUser(user)
  }
}
