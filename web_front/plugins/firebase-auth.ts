import {getAuth, onAuthStateChanged} from 'firebase/auth'
import CookieStore from '@/services/cookieStore'

export default () => {
  const auth = getAuth()
  onAuthStateChanged(auth, async user => {
    if (user) {
      const res = await user.getIdTokenResult()
      CookieStore.setAuth(res.token, res.expirationTime)
    }
  })
}
