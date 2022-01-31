import {User, getAuth, onAuthStateChanged} from 'firebase/auth'
import CookieStore from '@/services/cookieStore'

export const getUser = (): Promise<User | null> => {
  return new Promise(resolve => {
    onAuthStateChanged(getAuth(), resolve)
  })
}

export const tokenExpired = (): boolean => {
  const now = new Date()
  const expiration = CookieStore.getExpirationTime()
  return !expiration || expiration < now
}

export const refreshUserToken = async (): Promise<User | null> => {
  const user = await getUser()
  if (user) {
    const res = await user.getIdTokenResult(true) // forceRefresh
    CookieStore.setAuth(res.token, res.expirationTime)
    return new Promise(resolve => {
      resolve(user)
    })
  } else {
    // セッションが切れているとuserがnullとなる
    return new Promise(resolve => {
      resolve(null)
    })
  }
}
