import Cookies from 'js-cookie'
import {AccountRole} from '@/types/User'

const idTokenKey = 'idToken'
const expirationTimeKey = 'expirationTime'
const accountRoleKey = 'accountRole'

const CookieStore = {
  setAuth: (token: string, expirationTime: string) => {
    Cookies.set(idTokenKey, token)
    Cookies.set(expirationTimeKey, Date.parse(expirationTime).toString())
  },
  getIdToken: (): string | undefined => {
    return Cookies.get(idTokenKey)
  },
  getExpirationTime: (): Date | undefined => {
    const expirationTimeStr = Cookies.get(expirationTimeKey)
    return !expirationTimeStr ? undefined : new Date(Number(expirationTimeStr))
  },
  setAccountRole: (accountRole: AccountRole) => {
    Cookies.set(accountRoleKey, accountRole)
  },
  getAccountRole: (): string | undefined => {
    return Cookies.get(accountRoleKey)
  },
  clear: () => {
    Cookies.remove(idTokenKey)
    Cookies.remove(expirationTimeKey)
    Cookies.remove(accountRoleKey)
  },
  clearAccountRole: () => {
    Cookies.remove(accountRoleKey)
  },
}

export default CookieStore
