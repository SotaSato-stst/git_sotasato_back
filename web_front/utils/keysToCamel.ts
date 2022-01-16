const toCamel = (str: string) => {
  return str.replace(/([-_][a-z0-9])/gi, $1 => {
    return $1.toUpperCase().replace('-', '').replace('_', '')
  })
}

const isObject = function (obj: any) {
  return obj === Object(obj) && !Array.isArray(obj) && typeof obj !== 'function'
}

type O = {
  [key: string]: any
}

const keysToCamel = <T extends O, K extends keyof T>(obj: T): O => {
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

export default keysToCamel
