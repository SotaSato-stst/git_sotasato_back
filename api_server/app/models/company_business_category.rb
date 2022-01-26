# == Schema Information
#
# Table name: company_business_categories
#
#  id                :bigint           not null, primary key
#  business_category :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  company_id        :bigint           not null
#
# Indexes
#
#  index_company_business_categories_on_company_id  (company_id)
#  index_unique_company_business_categories         (company_id,business_category) UNIQUE
#
class CompanyBusinessCategory < ApplicationRecord
  belongs_to :company
  enum business_category: BusinessCategory.enum_hash
end
