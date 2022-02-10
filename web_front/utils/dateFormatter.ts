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
