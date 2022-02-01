import {Plugin} from '@nuxt/types'
import {getAuth, signOut} from 'firebase/auth'
import {initializeAxios} from '~/store/api'
import {notifyError} from '~/services/notify'
import isEmptyObject from '@/utils/isEmptyObject'
import {keysToCamel, keysToSnake} from '~/utils/keyConverter'
import CookieStore from '@/services/cookieStore'
import {tokenExpired, refreshUserToken} from '@/services/authService'

const accessor: Plugin = ({$axios}) => {
  $axios.onRequest(async request => {
    if (tokenExpired()) {
      const user = await refreshUserToken()
      if (!user) {
        // セッションが切れているため、サインアウトさせる必要がある
        signOut(getAuth())
        return {
          ...request,
          cancelToken: new $axios.CancelToken(cancel =>
            cancel('No authrization'),
          ),
        }
      }
    }
    request.params = {
      token: CookieStore.getIdToken(),
    }
    request.params = {
      ...keysToSnake(request.params),
    }
    request.data = {
      ...keysToSnake(request.data),
    }
    return request
  })

  // レスポンスJSONのキーをスネークケースからキャメルケースに変換
  $axios.onResponse(response => {
    if (
      !response.data ||
      typeof response.data !== 'object' ||
      isEmptyObject(response.data)
    ) {
      return response
    }

    response.data = keysToCamel(response.data)
    return response
  })

  $axios.onError(error => {
    if (!error.response) {
      notifyError('エラー', '通信に失敗しました')
      return
    }
    const auth = getAuth()
    switch (error.response.status) {
      case 401:
        notifyError('セッションエラー', 'ログインが必要です')
        signOut(auth)
        break
      case 403:
        notifyError(
          '操作エラー',
          error.response.data.message || '閲覧権限がありません。',
        )
        break
      case 404:
        break
      default:
        notifyError(
          error.response.status.toString(),
          error.response.data.message ||
            'サーバーエラーが発生しました。問題がある場合はお問い合わせください。',
        )
        break
    }
  })

  initializeAxios($axios)
}

export default accessor
