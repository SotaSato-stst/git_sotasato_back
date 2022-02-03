import {getAuth, onAuthStateChanged} from 'firebase/auth'
import {Middleware} from '@nuxt/types'
import CookieStore from '@/services/cookieStore'
import {notifyInfo} from '@/services/notify'
import {routingService} from '~/services/routingService'

const signInPath = routingService.SignIn()

const session: Middleware = ({route, redirect}) => {
  const auth = getAuth()
  onAuthStateChanged(auth, async user => {
    if (!user && route.path !== signInPath) {
      notifyInfo('ログアウトしました', 'ログインが必要です')
      redirect(signInPath)
    }
    if (user) {
      const res = await user.getIdTokenResult()
      CookieStore.setAuth(res.token, res.expirationTime)
    }
  })
}

export default session
