export const convertToShortJPY = (price: number) => {
  const format = Intl.NumberFormat('ja-JP', {
    notation: 'compact',
    currency: 'JPY',
  })
  const oku = 100000000
  if (price > oku) {
    const underOKuDigitsNumber = 8
    const overDigits = price.toString().length - underOKuDigitsNumber
    const jpMan = Number(price.toString().substring(overDigits))
    const underOku = format.format(jpMan)
    const overOku = format.format(price - jpMan)
    if (jpMan === 0) {
      return overOku
    } else {
      return overOku + underOku
    }
  } else {
    return format.format(price)
  }
}
