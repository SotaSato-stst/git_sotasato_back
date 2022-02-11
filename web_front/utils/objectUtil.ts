export const isEmptyObject = (obj: object) => Object.keys(obj).length === 0

export const removeEmpty = (obj: any): any => {
  return Object.fromEntries(
    Object.entries(obj)
      .filter(([_, v]) => v != null)
      .map(([k, v]) => [k, v === Object(v) ? removeEmpty(v) : v]),
  )
}
