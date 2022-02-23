import {PublishingCode, SubsidyCategory} from '@/types/Subsidy'
import {AccountRole} from '@/types/User'

export const subsidyCategoryLabel = (category: SubsidyCategory) => {
  switch (category) {
    case 'hojo':
      return '補助金'
    case 'josei':
      return '助成金'
    case 'kyufu':
      return '給付金'
  }
}

export const publishingCodeLabel = (code: PublishingCode) => {
  switch (code) {
    case 'published':
      return '公開中'
    case 'editing':
      return '非公開中'
  }
}

export const accountRoleOptions = () => {
  return [
    {
      key: 'admin',
      name: 'すべての権限を持つ管理者',
    },
    {
      key: 'editor',
      name: '補助金情報の編集者',
    },
    {
      key: 'user',
      name: '一般ユーザー',
    },
  ]
}

export const accountRoleLabel = (accountRole: AccountRole) => {
  switch (accountRole) {
    case 'admin':
      return '管理者'
    case 'editor':
      return '情報編集者'
    case 'user':
      return '一般ユーザー'
  }
}
