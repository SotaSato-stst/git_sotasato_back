# == Schema Information
#
# Table name: subsidies
#
#  id                 :bigint           not null, primary key
#  capital_max        :integer
#  capital_min        :integer
#  detail             :text(65535)      not null
#  end_to             :date
#  level              :integer
#  price_max          :integer
#  publishing_code    :string(255)      not null
#  ranking_score      :integer
#  start_from         :date             not null
#  subsidy_category   :string(255)
#  supplier_type      :string(255)
#  support_ratio_max  :string(255)
#  support_ratio_min  :string(255)
#  target_detail      :text(65535)      not null
#  title              :string(255)      not null
#  total_employee_max :integer
#  total_employee_min :integer
#  url                :text(65535)      not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_subsidies_on_url  (url) UNIQUE
#
class Subsidy < ApplicationRecord
  has_one :subsidy_ministry, dependent: :destroy
  has_one :ministry, through: :subsidy_ministry
  has_one :subsidy_prefecture, dependent: :destroy
  has_one :prefecture, through: :subsidy_prefecture
  has_one :subsidy_city, dependent: :destroy
  has_one :city, through: :subsidy_city
  has_many :user_favorite_subsidies, dependent: :destroy
  has_many :subsidy_business_categories, dependent: :destroy
  has_many :users, through: :user_favorite_subsidies
  validates :title, presence: { message: 'は必須項目です' }
  validates :url, presence: { message: 'は必須項目です' }
  validates :detail, presence: { message: 'は必須項目です' }
  validates :target_detail, presence: { message: 'は必須項目です' }
  validates :start_from, presence: { message: 'は必須項目です' }
  validates :publishing_code, presence: { message: 'は必須項目です' }
  validate :supplier_type_must_have_association
  validate :start_from_cannot_be_greater_than_end_to
  validates_inclusion_of :level, in: 1..5, if: -> { level.present? }, message: 'は1から5の間にしてください'

  scope :published, -> { where(publishing_code: 'published') }
  scope :search_by_user, ->(search_params) {
    published
      .in_application_period(search_params[:in_application_period])
      .search_with_business_category(search_params[:business_category_keys])
      .search_with_prefecture(search_params[:prefecture_id])
      .search_with_city(search_params[:city_ids])
      .search_apply_employee(search_params[:total_employee])
      .search_apply_capital(search_params[:capital])
  }
  scope :search_with_prefecture, ->(prefecture_id) {
    return if prefecture_id.blank?

    scope = left_joins(:subsidy_prefecture)
    prefecture_nil = scope.where(subsidy_prefectures: { id: nil })
    scope.merge(SubsidyPrefecture.where(prefecture_id: prefecture_id)).or(prefecture_nil)
  }
  scope :search_with_city, ->(city_ids) {
    return if city_ids.blank?

    scope = left_joins(:subsidy_city)
    city_nil = scope.where(subsidy_cities: { id: nil })
    scope.merge(SubsidyCity.where(city_id: city_ids.to_s.split('|'))).or(city_nil)
  }
  scope :in_application_period, ->(checked) {
    return unless ActiveModel::Type::Boolean.new.cast(checked)

    merge(Subsidy.where(end_to: Date.today..).or(Subsidy.where(end_to: nil)))
  }
  scope :search_with_business_category, ->(business_category_keys) { # "seizo|kensetsu" のような形で受け取る
    return if business_category_keys.blank?

    scope = left_joins(:subsidy_business_categories)
    categories = SubsidyBusinessCategory.where(business_category: business_category_keys.to_s.split('|'))
    scope.merge(categories).or(scope.where(subsidy_business_categories: { id: nil }))
  }
  scope :search_apply_employee, ->(total_employee) {
    return if total_employee.blank?

    merge(Subsidy.where('total_employee_min < ?', total_employee).where(
      'total_employee_max > ?', total_employee).or(
        Subsidy.where('total_employee_min < ?', total_employee).where(
          total_employee_max: [nil, ''])).or(Subsidy.where(
            'total_employee_max > ?', total_employee).where(
              total_employee_min: [nil, ''])))
  }
  scope :search_apply_capital, ->(capital) {
    return if capital.blank?

    merge(Subsidy.where('capital_min < ?', capital).where(
      'capital_max > ?', capital).or(
        Subsidy.where('capital_min < ?', capital).where(
          capital_max: [nil, ''])).or(Subsidy.where(
            'capital_max > ?', capital).where(
              capital_min: [nil, ''])))
  }
  enum publishing_code: { published: 'published', editing: 'editing' }
  enum subsidy_category: { hojo: 'hojo', josei: 'josei' }
  enum supplier_type: { ministry: 'ministry', city: 'city', prefecture: 'prefecture' }

  def business_categories
    subsidy_business_categories.map do |subsidy_business_category|
      BusinessCategory.to_option(subsidy_business_category.business_category)
    end
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
