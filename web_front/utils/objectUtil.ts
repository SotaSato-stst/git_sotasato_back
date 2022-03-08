export const isEmptyObject = (obj: object) => Object.keys(obj).length === 0

export const removeEmpty = (obj: any): any => {
  return Object.fromEntries(
    Object.entries(obj)
      .filter(([_, v]) => v != null && v !== '' && v !== [])
      .map(([k, v]) => [
        k,
        v === Object(v) && !Array.isArray(v) && !(v instanceof Date)
          ? removeEmpty(v)
          : v,
      ]),
  )
}

export const removeSameValue = (obj: any, obj2: any): any => {
  return Object.fromEntries(
    Object.entries(obj).filter(([k, v]) => v !== obj2[k]),
  )
}
