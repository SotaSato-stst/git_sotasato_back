# == Schema Information
#
# Table name: user_favorite_subsidies
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  subsidy_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_favorite_subsidies_on_subsidy_id              (subsidy_id)
#  index_user_favorite_subsidies_on_user_id                 (user_id)
#  index_user_favorite_subsidies_on_user_id_and_subsidy_id  (user_id,subsidy_id) UNIQUE
#
FactoryBot.define do
  factory :user_favorite_subsidy do
    association(:user)
    association(:subsidy)
  end
end
