export type EmailCategory = 'new_subsidies'
export type EmailSubscribe = {
  name: string
  emailCategory: EmailCategory
  subscribed: boolean
}
export type UserEmailSubscribesResponse = {
  subscribes: EmailSubscribe[]
}
