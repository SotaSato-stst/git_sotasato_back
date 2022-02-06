import {Company} from './Company'
import {Pagination} from './Pagination'

export type AccountRole = 'admin' | 'editor' | 'user'

export type User = {
  id: number
  firebaseUid: string
  displayName: string
  email: string
  accountRole: AccountRole
  company: Company
}

export type UsersResponse = {
  users: User[]
  pagination: Pagination
}

export type NewUserParams = {
  displayName: string
  email: string
  accountRole: AccountRole
  companyId: number | null
}

export type UpdateUserParams = {
  displayName: string
  accountRole: AccountRole
  companyId: number | null
}
