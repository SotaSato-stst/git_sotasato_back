import {SubsidyCategory} from '@/types/Subsidy'
import {AccountRole} from '~/types/User'

export const subsidyCategoryLabel = (category: SubsidyCategory) => {
  switch (category) {
    case 'hojo':
      return '補助金'
    case 'josei':
      return '助成金'
  }
}

export const accountRoleOptions = () => {
  return [
    {
      key: 'admin',
      name: '管理者',
    },
    {
      key: 'editor',
      name: '情報編集者',
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
