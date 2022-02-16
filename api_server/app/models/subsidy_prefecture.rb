# == Schema Information
#
# Table name: subsidy_prefectures
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  prefecture_id :bigint           not null
#  subsidy_id    :bigint           not null
#
# Indexes
#
#  index_subsidy_prefectures_on_prefecture_id                 (prefecture_id)
#  index_subsidy_prefectures_on_subsidy_id                    (subsidy_id)
#  index_subsidy_prefectures_on_subsidy_id_and_prefecture_id  (subsidy_id,prefecture_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (prefecture_id => prefectures.id)
#  fk_rails_...  (subsidy_id => subsidies.id)
#
class SubsidyPrefecture < ApplicationRecord
  belongs_to :prefecture
  belongs_to :subsidy
end
