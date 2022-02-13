import {Middleware} from '@nuxt/types'
import {notifyError, notifyInfo} from '@/services/notify'
import {routingService} from '@/services/routingService'
import {getUser} from '@/services/authService'
import CookieStore from '@/services/cookieStore'

const sessionFreePaths = [
  routingService.SignIn(),
  routingService.PasswordReset(),
]

const middleware: Middleware = async ({route, redirect}) => {
  const user = await getUser()
  if (!user && !sessionFreePaths.includes(route.path)) {
    notifyInfo('ログアウトしました', 'ログインが必要です')
    redirect(routingService.SignIn())
  }
  if (
    route.path.startsWith('/admin') &&
    CookieStore.getAccountRole() !== 'admin' &&
    CookieStore.getAccountRole() !== 'editor'
  ) {
    redirect(routingService.Top())
  }

  if (window.$nuxt.isOffline) {
    notifyError(
      'インターネット接続がありません',
      'ネットワーク環境をご確認ください',
    )
  }
}

export default middleware
