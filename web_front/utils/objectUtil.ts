export const isEmptyObject = (obj: object) => Object.keys(obj).length === 0

export const removeEmpty = (obj: any): any => {
  return Object.fromEntries(
    Object.entries(obj)
      .filter(([_, v]) => v != null && v !== '')
      .map(([k, v]) => [
        k,
        v === Object(v) && !Array.isArray(v) ? removeEmpty(v) : v,
      ]),
  )
}
