class UserFavoriteSubsidy < ApplicationRecord
  belongs_to :user
  belongs_to :subsidy
end
