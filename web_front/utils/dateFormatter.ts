export const convertToJpDate = (date: Date, withYear: boolean = true) => {
  const options: Intl.DateTimeFormatOptions = {
    year: 'numeric',
    month: 'narrow',
    day: 'numeric',
  }
  if (!withYear) {
    options.year = undefined
  }
  const dateformat = new Intl.DateTimeFormat('ja-JP', options)
  return dateformat.format(new Date(date))
}

export const convertToJpDateTime = (date: Date) => {
  const options: Intl.DateTimeFormatOptions = {
    year: 'numeric',
    month: 'narrow',
    day: 'numeric',
    hour: 'numeric',
    minute: 'numeric',
  }
  const dateformat = new Intl.DateTimeFormat('ja-JP', options)
  return dateformat.format(new Date(date))
}

export const convertDateRange = (
  startFromStr?: string,
  endToStr?: string,
): string | null => {
  if (startFromStr && endToStr) {
    const startFrom = new Date(startFromStr)
    const endTo = new Date(endToStr)
    const diffYear = startFrom.getFullYear() !== endTo.getFullYear()
    return `${convertToJpDate(startFrom)} ~ ${convertToJpDate(endTo, diffYear)}`
  } else if (startFromStr && !endToStr) {
    const startFrom = new Date(startFromStr)
    return `${convertToJpDate(startFrom)} ~`
  } else if (!startFromStr && endToStr) {
    const endTo = new Date(endToStr)
    return `~ ${convertToJpDate(endTo)}`
  } else {
    return null
  }
}
