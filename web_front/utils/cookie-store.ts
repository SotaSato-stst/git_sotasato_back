import Cookies from 'js-cookie'

const idTokenKey = 'idToken'
const expirationTimeKey = 'expirationTime'

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
}

export default CookieStore
