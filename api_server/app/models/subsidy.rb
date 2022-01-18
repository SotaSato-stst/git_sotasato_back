# == Schema Information
#
# Table name: subsidies
#
#  id                :bigint           not null, primary key
#  detail            :text(65535)      not null
#  end_to            :date
#  level             :integer
#  price_max         :integer
#  publishing_code   :string(255)      not null
#  start_from        :date             not null
#  support_ratio_max :string(255)
#  support_ratio_min :string(255)
#  target_detail     :text(65535)      not null
#  title             :string(255)      not null
#  url               :text(65535)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
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
  validates_inclusion_of :level, in: 1..5, if: -> { level.present? }
  def start_from_cannot_be_greater_than_end_to
    return if start_from.blank? || end_to.blank? || start_from < end_to

    errors.add(:start_from, 'を上回ることはできません')
  end
  enum publishing_code: { published: 'published', editing: 'editing' }
end
