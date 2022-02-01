import {SubsidyCategory} from '@/types/Subsidy'

export const subsidyCategoryLabel = (category: SubsidyCategory) => {
  switch (category) {
    case 'hojo':
      return '補助金'
    case 'josei':
      return '助成金'
  }
}
