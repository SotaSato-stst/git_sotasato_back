# == Schema Information
#
# Table name: subsidy_keywords
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  keyword_id :bigint           not null
#  subsidy_id :bigint           not null
#
# Indexes
#
#  index_subsidy_keywords_on_keyword_id                 (keyword_id)
#  index_subsidy_keywords_on_subsidy_id                 (subsidy_id)
#  index_subsidy_keywords_on_subsidy_id_and_keyword_id  (subsidy_id,keyword_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (keyword_id => keywords.id)
#  fk_rails_...  (subsidy_id => subsidies.id)
#
class SubsidyKeyword < ApplicationRecord
  belongs_to :keyword
  belongs_to :subsidy
end
