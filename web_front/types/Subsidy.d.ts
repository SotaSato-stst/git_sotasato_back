export type Subsidy = {
  id: number
  title: string
  url: string
}

export type SubsidiesResponse = {
  subsidies: Subsidy[]
  currentPage: number
  totalPages: number
}
