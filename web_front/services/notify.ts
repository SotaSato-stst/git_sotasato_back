import {Notification} from 'element-ui'
import {ElNotificationOptions} from 'element-ui/types/notification'

export const notify = (options: ElNotificationOptions) => Notification(options)

export const notifySuccess = (title: string, message: string) => {
  notify({
    title,
    type: 'success',
    message,
    duration: 5000,
    dangerouslyUseHTMLString: true,
  })
}

export const notifyError = (title: string, message: string) => {
  notify({
    title,
    type: 'error',
    message,
    duration: 5000,
    dangerouslyUseHTMLString: true,
  })
}

export const notifyInfo = (title: string, message: string) => {
  notify({
    title,
    type: 'info',
    message,
    duration: 5000,
    dangerouslyUseHTMLString: true,
  })
}

export const notifyWarning = (title: string, message: string) => {
  notify({
    title,
    type: 'warning',
    message,
    duration: 5000,
    dangerouslyUseHTMLString: true,
  })
}

export const showApiErrorMessage = (error: any) => {
  notifyError(
    error.response?.data?.message || '更新に失敗しました',
    error.response?.data?.errors?.join('<br/>') || '入力内容を確認してください',
  )
}
