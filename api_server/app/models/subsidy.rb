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
#  subsidy_category  :string(255)
#  supplier_type     :string(255)
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
  has_many :user, through: :user_favorite_subsidy
  validate :supplier_type_must_have_association
  validate :start_from_cannot_be_greater_than_end_to
  validates_inclusion_of :level, in: 1..5, if: -> { level.present? }

  scope :published, -> { where(publishing_code: 'published') }

  enum publishing_code: { published: 'published', editing: 'editing' }
  enum subsidy_category: { hojo: 'hojo', josei: 'josei' }
  enum supplier_type: { ministry: 'ministry', city: 'city', prefecture: 'prefecture' }

  def business_categories
    [] # TODO
  end

  def start_from_cannot_be_greater_than_end_to
    return if start_from.blank? || end_to.blank? || start_from < end_to

    errors.add(:start_from, 'を上回ることはできません')
  end

  def supplier_type_must_have_association
    if supplier_type == 'ministry' && subsidy_ministry.blank?
      errors.add(:supplier_type, 'ministryが存在しません')
    end
    if supplier_type == 'prefecture' && subsidy_prefecture.blank?
      errors.add(:supplier_type, 'prefectureが存在しません')
    end
    if supplier_type == 'city' && (subsidy_city.blank? || subsidy_prefecture.blank?)
      errors.add(:supplier_type, 'cityが存在しません')
    end
  end
end
