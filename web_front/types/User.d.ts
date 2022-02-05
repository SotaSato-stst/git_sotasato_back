import {Pagination} from './Pagination'

export type AccountRole = 'admin' | 'editor' | 'user'

export type User = {
  id: number
  firebaseUid: string
  displayName: string
  email: string
  accountRole: AccountRole
}

export type UsersResponse = {
  users: User[]
  pagination: Pagination
}

export type NewUserParams = {
  displayName: string
  email: string
  accountRole: AccountRole
}

export type UpdateUserParams = {
  displayName: string
  accountRole: AccountRole
}
