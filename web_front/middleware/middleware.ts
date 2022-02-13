import {Middleware} from '@nuxt/types'
import {notifyError, notifyInfo} from '@/services/notify'
import {routingService} from '~/services/routingService'
import {getUser} from '@/services/authService'

const signInPath = routingService.SignIn()

const middleware: Middleware = async ({route, redirect}) => {
  const user = await getUser()
  if (!user && route.path !== signInPath) {
    notifyInfo('ログアウトしました', 'ログインが必要です')
    redirect(signInPath)
  }

  if (window.$nuxt.isOffline) {
    notifyError(
      'インターネット接続がありません',
      'ネットワーク環境をご確認ください',
    )
  }
}

export default middleware
