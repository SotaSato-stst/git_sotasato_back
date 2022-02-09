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
  has_many :user_favorite_subsidies
  has_many :users, through: :user_favorite_subsidies
  validates :title, presence: { message: 'は必須項目です' }
  validates :url, presence: { message: 'は必須項目です' }
  validates :detail, presence: { message: 'は必須項目です' }
  validates :target_detail, presence: { message: 'は必須項目です' }
  validates :start_from, presence: { message: 'は必須項目です' }
  validates :publishing_code, presence: { message: 'は必須項目です' }
  validate :supplier_type_must_have_association
  validate :start_from_cannot_be_greater_than_end_to
  validates_inclusion_of :level, in: 1..5, if: -> { level.present? }

  scope :published, -> { where(publishing_code: 'published') }
  scope :search_by_user, ->(search_params) {
    published
      .search_with_prefecture(search_params[:prefecture_ids])
      .search_with_city(search_params[:city_ids])
  }
  scope :search_with_prefecture, ->(prefecture_ids) { # "1|2|3" のような形で受け取る
    joins(:prefecture).merge(Prefecture.where(id: prefecture_ids.to_s.split('|'))) if prefecture_ids.present?
  }
  scope :search_with_city, ->(city_ids) { # "1|2|3" のような形で受け取る
    joins(:city).merge(City.where(id: city_ids.to_s.split('|'))) if city_ids.present?
  }

  enum publishing_code: { published: 'published', editing: 'editing' }
  enum subsidy_category: { hojo: 'hojo', josei: 'josei' }
  enum supplier_type: { ministry: 'ministry', city: 'city', prefecture: 'prefecture' }

  def business_categories
    [] # TODO
  end

  def start_from_cannot_be_greater_than_end_to
    return if start_from.blank? || end_to.blank? || start_from < end_to

    errors.add(:start_from, 'の前に終了日を設置できません')
  end

  def supplier_type_must_have_association
    if supplier_type == 'ministry' && subsidy_ministry.blank?
      errors.add(:supplier_type, 'の省庁の指定は必須です')
    end
    if supplier_type == 'prefecture' && subsidy_prefecture.blank?
      errors.add(:supplier_type, 'の都道府県の指定は必須です')
    end
    if supplier_type == 'city' && (subsidy_city.blank? || subsidy_prefecture.blank?)
      errors.add(:supplier_type, 'の市長区村の指定は必須です')
    end
  end
end
