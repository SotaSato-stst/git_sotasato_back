import {getAuth, onAuthStateChanged} from 'firebase/auth'
import {Middleware} from '@nuxt/types'
import CookieStore from '@/services/cookieStore'
import {notifyError} from '@/services/notify'

const signInPath = '/sign-in'

const session: Middleware = ({route, redirect}) => {
  const auth = getAuth()
  onAuthStateChanged(auth, async user => {
    if (!user && route.path !== signInPath) {
      notifyError('セッションエラー', 'ログインが必要です')
      redirect(signInPath)
    }
    if (user) {
      const res = await user.getIdTokenResult()
      CookieStore.setAuth(res.token, res.expirationTime)
    }
  })
}

export default session
