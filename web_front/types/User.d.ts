import {Company, CurrentCompany} from './Company'
import {Pagination} from './Pagination'

export type AccountRole = 'admin' | 'editor' | 'user'

export type User = {
  id: number
  displayName: string
  lastName: string
  firstName: string
  email: string
  accountRole: AccountRole
  disabled: boolean
  company: Company
}

export type CurrentUser = {
  displayName: string
  lastName: string
  firstName: string
  email: string
  accountRole: AccountRole
  company: CurrentCompany
}

export type UsersResponse = {
  users: User[]
  pagination: Pagination
}

export type UserParams = {
  lastName: string
  firstName: string
  email: string
  accountRole: AccountRole
  companyId: number | null
  disabled: boolean
}

export type UpdateCurrentUserParams = {
  lastName: string
  firstName: string
  email: string
}
