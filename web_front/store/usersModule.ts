import {Action, Module, Mutation, VuexModule} from 'vuex-module-decorators'
import {$axios} from '@/store/api'
import {
  User,
  UsersResponse,
  NewUserParams,
  UpdateUserParams,
} from '@/types/User'
import {useLoader} from '@/services/useLoader'
import {Pagination} from '@/types/Pagination'

@Module({
  name: 'usersModule',
  stateFactory: true,
  namespaced: true,
})
export default class UsersModule extends VuexModule {
  loader = useLoader()
  users: User[] = []
  user: User | null = null
  pagination: Pagination = {
    currentPage: 0,
    totalPages: 0,
    itemsTotal: 0,
    itemsPerPage: 0,
  }

  rules = {
    companyId: [
      {
        required: true,
        message: '所属は必須です',
        trigger: 'change',
      },
    ],
    displayName: [
      {
        required: true,
        message: '氏名は必須です',
        trigger: 'change',
      },
    ],
    email: [
      {
        type: 'email',
        required: true,
        message: 'メールアドレスを入力してください',
        trigger: 'change',
      },
    ],
    accountRole: [
      {
        required: true,
        message: 'アカウント種類は必須です',
        trigger: 'change',
      },
    ],
  }

  @Mutation
  setUsers(users: User[]) {
    this.users = users
  }

  @Mutation
  setUser(user: User | null) {
    this.user = user
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
  async postUser(params: NewUserParams) {
    const user = await $axios.$post<User>('/admin/users', {
      ...params,
    })
    this.setUser(user)
  }

  @Action({rawError: true})
  async putUser(params: UpdateUserParams) {
    if (!this.user) {
      return
    }
    const user = await $axios.$put<User>(`/admin/users/${this.user.id}`, {
      ...params,
    })
    this.setUser(user)
  }
}
