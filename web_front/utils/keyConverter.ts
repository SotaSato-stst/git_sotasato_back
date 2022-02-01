const toCamel = (str: string) => {
  return str.replace(/([-_][a-z0-9])/gi, $1 => {
    return $1.toUpperCase().replace('-', '').replace('_', '')
  })
}

const toSnake = (str: string) =>
  str.replace(/[A-Z]/g, letter => `_${letter.toLowerCase()}`)

const isObject = function (obj: any) {
  return obj === Object(obj) && !Array.isArray(obj) && typeof obj !== 'function'
}

type O = {
  [key: string]: any
}

export const keysToCamel = <T extends O, K extends keyof T>(obj: T): O => {
  if (isObject(obj)) {
    const n: O = {}

    Object.keys(obj).forEach(k => {
      n[toCamel(k)] = keysToCamel(obj[k as K])
    })

    return n
  } else if (Array.isArray(obj)) {
    return obj.map(i => {
      return keysToCamel(i)
    })
  }

  return obj
}

export const keysToSnake = <T extends O, K extends keyof T>(obj: T): O => {
  if (isObject(obj)) {
    const n: O = {}

    Object.keys(obj).forEach(k => {
      n[toSnake(k)] = keysToSnake(obj[k as K])
    })

    return n
  } else if (Array.isArray(obj)) {
    return obj.map(i => {
      return keysToSnake(i)
    })
  }

  return obj
}
