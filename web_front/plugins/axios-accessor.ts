import {Plugin} from '@nuxt/types'
// import webStorage from '@/utils/webStorage'
import {initializeAxios} from '@/utils/api'
import notify from '@/plugins/notify'
import isEmptyObject from '~/utils/isEmptyObject'
import keysToCamel from '~/utils/keysToCamel'

const accessor: Plugin = ({$axios}) => {
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

  $axios.onRequest(request => {
    if (request.url !== '/sign_in') {
      // request.headers['access-token'] = webStorage.getAccessToken()
      // request.headers['Content-Type'] = 'application/json'
    }
  })

  $axios.onError(error => {
    if (error.response !== undefined) {
      switch (error.response.status) {
        case 401:
          notify({
            title: 'セッションエラー',
            type: 'error',
            message:
              error.response.data.message || 'ログインをし直してください。',
            duration: 20000,
          })
          break
        case 403:
          notify({
            title: '操作エラー',
            type: 'error',
            message: error.response.data.message || '閲覧権限がありません。',
            duration: 20000,
          })
          break
        case 404:
          break
        default:
          notify({
            title: error.response.status.toString(),
            type: 'error',
            message:
              error.response.data.message ||
              'サーバーエラーが発生しました。問題がある場合はお問い合わせください。',
            duration: 20000,
          })
          break
      }
    }
  })

  initializeAxios($axios)
}

export default accessor
