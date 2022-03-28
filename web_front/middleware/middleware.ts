import {Middleware} from '@nuxt/types'
import {notifyError, notifyInfo} from '@/services/notify'
import {routingService} from '@/services/routingService'
import {getUser} from '@/services/authService'
import CookieStore from '@/services/cookieStore'

const sessionFreePaths = [
  routingService.SignIn(),
  routingService.PasswordReset(),
]

const editorPrefixes = [
  '/admin/subsidies',
  '/admin/subsidy_drafts',
  '/admin/benefits',
]

const middleware: Middleware = async ({route, redirect}) => {
  const user = await getUser()
  if (!user && !sessionFreePaths.includes(route.path)) {
    notifyInfo('ログアウトしました', 'ログインが必要です')

    let redirection: string | null = null
    if (route.path === '/account') {
      redirection = 'account'
    }
    redirect(routingService.SignIn(redirection))
  }

  // 一般ユーザーが管理画面にアクセスできないようにする
  // ※cookieを書き換えればアクセスできるが、APIで弾いており情報は取得できない
  if (
    route.path.startsWith('/admin') &&
    CookieStore.getAccountRole() !== 'admin' &&
    CookieStore.getAccountRole() !== 'editor'
  ) {
    redirect(routingService.Top())
  }

  // 編集者(editor)が権限のないURLにアクセスできないようにする
  if (
    CookieStore.getAccountRole() === 'editor' &&
    route.path.startsWith('/admin') &&
    route.path !== routingService.AdminTop() &&
    !editorPrefixes.find(prefix => route.path.startsWith(prefix))
  ) {
    redirect(routingService.AdminTop())
  }

  if (window.$nuxt.isOffline) {
    notifyError(
      'インターネット接続がありません',
      'ネットワーク環境をご確認ください',
    )
  }
}

export default middleware
