import {Notification} from 'element-ui'
import {ElNotificationOptions} from 'element-ui/types/notification'

export const notify = (options: ElNotificationOptions) => Notification(options)

export const notifyError = (title: string, message: string) => {
  notify({
    title,
    type: 'error',
    message,
    duration: 20000,
  })
}
