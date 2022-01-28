export const convertToJpDate = (date: Date) => {
  const dateformat = new Intl.DateTimeFormat('ja-JP', {
    year: 'numeric',
    month: 'narrow',
    day: 'numeric',
  })
  return dateformat.format(new Date(date))
}
