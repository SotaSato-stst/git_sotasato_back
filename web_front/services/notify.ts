import {Notification} from 'element-ui'
import {ElNotificationOptions} from 'element-ui/types/notification'

export const notify = (options: ElNotificationOptions) => Notification(options)

export const notifySuccess = (title: string, message: string) => {
  notify({
    title,
    type: 'success',
    message,
    duration: 5000,
  })
}

export const notifyError = (title: string, message: string) => {
  notify({
    title,
    type: 'error',
    message,
    duration: 5000,
  })
}

export const notifyInfo = (title: string, message: string) => {
  notify({
    title,
    type: 'info',
    message,
    duration: 5000,
  })
}

export const notifyWarning = (title: string, message: string) => {
  notify({
    title,
    type: 'warning',
    message,
    duration: 5000,
  })
}
