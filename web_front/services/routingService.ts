type PageUrl = string

export const routingService: {
  [key: string]: (...args: any[]) => PageUrl
} = {
  Top: () => '/',
  SignIn: () => '/sign-in',
  SubsidyDetail: (id: number) => `/subsidies/${id}`,
  Ranking: () => '/ranking',
  Favorite: () => '/favorite',
  AdminTop: () => '/admin',
  AdminSubsidyDraftDetail: (id: number) => `/admin/subsidy_drafts/${id}`,
  AdminSubsidies: () => '/admin/subsidies',
  AdminSubsidyDetail: (id: number) => `/admin/subsidies/${id}`,
  AdminCompanies: () => '/admin/companies',
  AdminNewCompany: () => '/admin/companies/new',
  AdminCompanyDetail: (id: number) => `/admin/companies/${id}`,
  AdminUsers: () => '/admin/users',
  AdminNewUser: () => '/admin/users/new',
  AdminUserDetail: (id: number) => `/admin/users/${id}`,
} as const
