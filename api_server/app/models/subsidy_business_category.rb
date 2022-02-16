# == Schema Information
#
# Table name: subsidy_business_categories
#
#  id                :bigint           not null, primary key
#  business_category :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  subsidy_id        :bigint           not null
#
# Indexes
#
#  index_subsidy_business_categories_on_subsidy_id  (subsidy_id)
#  index_unique_subsidy_business_categories         (subsidy_id,business_category) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (subsidy_id => subsidies.id)
#
class SubsidyBusinessCategory < ApplicationRecord
  belongs_to :subsidy
  enum business_category: BusinessCategory.enum_hash
end
