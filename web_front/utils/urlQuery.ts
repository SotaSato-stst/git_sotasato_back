import {removeNull} from '@/utils/arrayUtil'

type queryValue = string | (string | null)[]

export const convertQueryString = (value: queryValue) => {
  return value?.toString() || null
}

export const convertQueryNumber = (value: queryValue) => {
  return value && !isNaN(Number(value)) ? Number(value) : null
}

export const convertQueryArray = (value: queryValue) => {
  if (!value) {
    return null
  }
  return Array.isArray(value) ? (removeNull(value) as string[]) : [value]
}

export const convertQueryDate = (value: queryValue) => {
  return value ? new Date(value.toString()) : null
}
