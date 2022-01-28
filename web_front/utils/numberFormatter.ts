export const convertToShortJPY = (price: number) => {
  const format = Intl.NumberFormat('ja-JP', {
    notation: 'compact',
    currency: 'JPY',
  })
  const oku = 100000000
  if (price > oku) {
    const underOKuDigitsNumber = 8
    const overDigits = price.toString().length - underOKuDigitsNumber
    const jpMan = Number(price.toString().substr(overDigits))
    const underOku = format.format(jpMan)
    const overOku = format.format(price)
    return overOku + underOku
  } else {
    return format.format(price)
  }
}
