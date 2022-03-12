type PageUrl = string

export const routingService: {
  [key: string]: (...args: any[]) => PageUrl
} = {
  Top: () => '/',
  SignIn: (redirection?: string) =>
    `/sign-in${redirection ? `?redirection=${redirection}` : ''}`,
  PasswordReset: () => '/password-reset',
  SubsidyDetail: (id: number) => `/subsidies/${id}`,
  InquirySubsidy: (id: number) => `/inquiries/${id}`,
  Ranking: () => '/ranking',
  Favorite: () => '/favorite',
  Account: () => '/account',
  EmailSetting: () => '/email-setting',
  NotFound: () => '/not_found',
  AdminTop: () => '/admin',
  AdminSubsidyDraftDetail: (id: number) => `/admin/subsidy_drafts/${id}`,
  AdminSubsidies: () => '/admin/subsidies',
  AdminNewSubsidy: () => '/admin/subsidies/new',
  AdminSubsidyDetail: (id: number) => `/admin/subsidies/${id}`,
  AdminCompanies: () => '/admin/companies',
  AdminNewCompany: () => '/admin/companies/new',
  AdminCompanyDetail: (id: number) => `/admin/companies/${id}`,
  AdminUsers: () => '/admin/users',
  AdminNewUser: () => '/admin/users/new',
  AdminUserDetail: (id: number) => `/admin/users/${id}`,
  AdminSearchedKeywords: () => '/admin/searched_keywords',
  AdminAssignees: () => '/admin/assignees',
} as const
