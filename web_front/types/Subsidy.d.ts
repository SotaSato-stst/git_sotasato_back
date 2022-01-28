export type Subsidy = {
  id: number
  title: string
  url: string
  startFrom: Date
  endTo: Date
  publishingCode: string
  priceMax: number
  supportRatioMin: string
  supportRatioMax: string
  level: number
  detail: string
  targetDetail: string
  subsidyCategory: string
  supplierType: string
  ministry: {
    id: number
    name: string
    logoUrl: string
  }
  prefecture: {
    id: number
    name: string
    logoUrl: string
  }
  city: {
    id: number
    name: string
    logoUrl: string
    prefectureId: number
  }
}

// export type Prefecture = {
//   id: number
//   name: string
//   logoUrl: string
// }

// export type PrefecturesResponse = {
//   prefectures: Prefecture[]
//   currentPage: number
//   totalPages: number
// }
// export type Ministry = {
//   id: number
//   name: string
//   logoUrl: string
// }

// export type MinistriesResponse = {
//   ministries: Ministry[]
//   currentPage: number
//   totalPages: number
// }
// export type City = {
//   id: number
//   name: string
//   logoUrl: string
// }

// export type CitiesResponse = {
//   cities: City[]
//   currentPage: number
//   totalPages: number
// }

export type SubsidiesResponse = {
  subsidies: Subsidy[]
  currentPage: number
  totalPages: number
}
