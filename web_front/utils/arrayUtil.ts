export const filterUniqueObj = (array: any[], uniqueKey: string) => {
  const ids = array.map(s => s[uniqueKey])
  const uniqueIndexes = [...new Set(ids.map(id => ids.indexOf(id)))]
  return uniqueIndexes.map(index => array[index])
}

export const removeNull = <T>(array: T[]) => {
  return array.filter(v => v !== null) as T[]
}
