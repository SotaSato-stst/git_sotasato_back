import Cookie from 'cookie-universal'

class WebStorage {
  cookies: any
  setOptions: any

  constructor() {
    this.cookies = Cookie()
    this.setOptions = {
      path: '/',
      secure: true,
    }
  }

  getAccessToken(): string {
    return this.cookies.get('accessToken')
  }

  getExpiry(): string {
    return this.cookies.get('expiry')
  }

  getUid(): string {
    return this.cookies.get('uid')
  }

  getClient(): string {
    return this.cookies.get('client')
  }

  setWithExpires(key: string, value: string, expires: Date) {
    const setOptions = this.setOptions
    setOptions.expires = expires
    this.cookies.set(key, value, setOptions)
  }

  setAccessToken(accessToken: string, expires: Date) {
    this.setWithExpires('accessToken', accessToken, expires)
  }

  setExpiry(expiry: string, expires: Date) {
    this.setWithExpires('expiry', expiry, expires)
  }

  setClient(client: string, expires: Date) {
    this.setWithExpires('client', client, expires)
  }

  clear() {
    this.cookies.removeAll()
  }
}

export default new WebStorage()
