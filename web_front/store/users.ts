import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {User, UsersResponse, UserParams} from '@/types/User'
import {Pagination} from '@/types/Pagination'

@Module({
  name: 'users',
  stateFactory: true,
  namespaced: true,
})
export default class UsersModule extends VuexModule {
  users: User[] = []
  user: User | null = null
  pagination: Pagination = {
    currentPage: 0,
    totalPages: 0,
    itemsTotal: 0,
    itemsPerPage: 0,
  }

  userParams: UserParams = {
    displayName: '',
    email: '',
    accountRole: 'user',
  }

  @Mutation
  setUsers(users: User[]) {
    this.users = users
  }

  @Mutation
  setUser(user: User | null) {
    this.user = user
    if (!user) {
      return
    }
    this.userParams = {
      displayName: user.displayName,
      email: user.email,
      accountRole: user.accountRole,
    }
  }

  @Mutation
  setUserParams(userParams: UserParams) {
    this.userParams = userParams
  }

  @Mutation
  setPagination(pagination: Pagination) {
    this.pagination = pagination
  }

  @Action({rawError: true})
  async getUsers(page?: number) {
    const res = await $axios.$get<UsersResponse>('/admin/users', {
      params: {page: page || 1},
    })
    this.setUsers(res.users)
    this.setPagination(res.pagination)
  }

  @Action({rawError: true})
  async getUser(id: number) {
    const user = await $axios.$get<User>(`/admin/users/${id}`)
    this.setUser(user)
  }

  @Action({rawError: true})
  async postUser() {
    const user = await $axios.$post<User>('/admin/users', this.userParams)
    this.setUser(user)
  }

  @Action({rawError: true})
  async putUser(userId: number) {
    const user = await $axios.$put<User>(
      `/admin/users/${userId}`,
      this.userParams,
    )
    this.setUser(user)
  }
}
