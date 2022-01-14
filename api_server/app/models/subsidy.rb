# == Schema Information
#
# Table name: subsidies
#
#  id         :bigint           not null, primary key
#  end_to     :date
#  start_from :date             not null
#  title      :string(255)      not null
#  url        :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_subsidies_on_url  (url) UNIQUE
#


class Subsidy < ApplicationRecord
  has_one :subsidy_ministry
  has_one :ministry, through: :subsidy_ministry
  has_one :subsidy_prefecture
  has_one :prefecture, through: :subsidy_prefecture
  has_one :subsidy_city
  has_one :city, through: :subsidy_city

  validate :start_from_cannot_be_greater_than_end_to

  def start_from_cannot_be_greater_than_end_to
    if start_from > end_to
      errors.add(:start_from, "を上回ることはできません")
    end
  end
end
