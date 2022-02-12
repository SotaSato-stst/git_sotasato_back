import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {UpdateCurrentUserParams, User} from '@/types/User'
import {useLoader} from '~/services/useLoader'

@Module({
  name: 'accountModule',
  stateFactory: true,
  namespaced: true,
})
export default class AccountModule extends VuexModule {
  loader = useLoader()
  currentUser: User | null = null

  @Mutation
  setCurrentUser(currentUser: User) {
    this.currentUser = currentUser
  }

  @Action({rawError: true})
  async getCurrentUser() {
    const user = await $axios.$get<User>('/current_user')
    this.setCurrentUser(user)
  }

  @Action({rawError: true})
  async putCurrentUser(params: UpdateCurrentUserParams) {
    const user = await $axios.$put<User>('/current_user', {
      ...params,
    })
    this.setCurrentUser(user)
  }
}
