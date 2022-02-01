export const starView = (num: number) => {
  return '★'.repeat(num) + '☆'.repeat(5 - num)
}
