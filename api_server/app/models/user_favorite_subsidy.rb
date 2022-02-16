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
# Foreign Keys
#
#  fk_rails_...  (subsidy_id => subsidies.id)
#  fk_rails_...  (user_id => users.id)
#
class UserFavoriteSubsidy < ApplicationRecord
  belongs_to :user
  belongs_to :subsidy

  # validates :subsidy_id, uniqueness: { scope: :user_id }
end
