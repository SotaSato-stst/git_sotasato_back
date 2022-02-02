type PageUrl = string

export const routingService: {[key: string]: (...args: any[]) => PageUrl} = {
  Top: () => '/',
  SubsidyDetail: (id: number) => `/subsidies/${id}`,
  Ranking: () => '/ranking',
  Favorite: () => '/favorite',
  AdminTop: () => '/admin',
  AdminSubsidies: () => '/admin/subsidies',
  AdminSubsidyDetail: (id: number) => `/admin/subsidies/${id}`,
  AdminCompanies: () => '/admin/companies',
  AdminCompanyDetail: (id: number) => `/admin/companies/${id}`,
  AdminUsers: () => '/admin/users',
  AdminUserDetail: (id: number) => `/admin/users/${id}`,
} as const
