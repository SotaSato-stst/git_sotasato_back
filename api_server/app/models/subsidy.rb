# == Schema Information
#
# Table name: subsidies
#
#  id                     :bigint           not null, primary key
#  annual_sales_max       :bigint
#  annual_sales_min       :bigint
#  capital_max            :bigint
#  capital_min            :bigint
#  catch_copy             :string(255)
#  detail                 :text(65535)      not null
#  end_to                 :date
#  level                  :integer
#  price_max              :bigint
#  publishing_code        :string(255)      not null
#  ranking_score          :integer
#  start_from             :date
#  subsidy_category       :string(255)
#  supplier_type          :string(255)
#  support_ratio_max      :string(255)
#  support_ratio_min      :string(255)
#  target_detail          :text(65535)      not null
#  title                  :string(255)      not null
#  total_employee_max     :integer
#  total_employee_min     :integer
#  url                    :text(65535)      not null
#  years_of_establishment :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_subsidies_on_price_max      (price_max)
#  index_subsidies_on_ranking_score  (ranking_score)
#  index_subsidies_on_url            (url) UNIQUE
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
  has_many :subsidy_organization_types, dependent: :destroy
  has_many :subsidy_keywords, dependent: :destroy
  has_many :users, through: :user_favorite_subsidies
  validates :title, presence: { message: 'は必須項目です' }
  validates :url, presence: { message: 'は必須項目です' }
  validates :url, uniqueness: { message: 'はすでに登録済みです' }
  validates :detail, presence: { message: 'は必須項目です' }
  validates :target_detail, presence: { message: 'は必須項目です' }
  validates :publishing_code, presence: { message: 'は必須項目です' }
  validate :supplier_type_must_have_association
  validate :start_from_cannot_be_greater_than_end_to
  validates_inclusion_of :level, in: 1..5, if: -> { level.present? }, message: 'は1から5の間にしてください'

  enum publishing_code: { published: 'published', editing: 'editing', archived: 'archived' }
  enum subsidy_category: { hojo: 'hojo', josei: 'josei', kyufu: 'kyufu' }
  enum supplier_type: { ministry: 'ministry', city: 'city', prefecture: 'prefecture' }

  scope :published, -> { where(publishing_code: 'published') }
  scope :index_loading, -> {
    includes(
      :ministry,
      :prefecture,
      :city,
      :subsidy_organization_types,
      :subsidy_business_categories,
      { subsidy_keywords: :keyword }
    )
  }
  scope :scope_by_user, ->(user) {
    company = user.company
    published
      .in_application_period(true)
      .search_by_organization_type(company.organization_type)
      .search_with_business_category(company.business_category_keys)
      .search_with_prefecture(company.prefecture_id)
      .search_with_city(company.city_id)
      .search_with_employee(company.total_employee)
      .search_with_capital(company.capital)
      .search_with_annual_sales(company.annual_sales)
      .in_years_of_establishment(company.founding_date)
  }
  scope :search_by_user, ->(search_params) {
    published
      .in_application_period(search_params[:in_application_period])
      .search_by_keyword(search_params[:keyword])
      .search_by_organization_type(search_params[:organization_type])
      .search_with_business_category(search_params[:business_category_keys])
      .search_with_prefecture(search_params[:prefecture_id])
      .search_with_city(search_params[:city_ids])
      .search_with_employee(search_params[:total_employee])
      .search_with_capital(search_params[:capital])
      .search_with_annual_sales(search_params[:annual_sales])
      .in_years_of_establishment(search_params[:founding_date])
  }
  scope :search_by_keyword, ->(keyword) {
    return if keyword.blank?

    keywords = Keyword.where(content: keyword.split(/[[:space:]]/))
    subsidy_ids = SubsidyKeyword.where(keyword: keywords).pluck(:subsidy_id)
    merge(where(id: subsidy_ids)).or(where('title like ?', "%#{keyword}%"))
  }
  scope :search_by_organization_type, ->(organization_type) {
    return if organization_type.blank?

    scope = left_joins(:subsidy_organization_types)
    types = SubsidyOrganizationType.where(organization_type: organization_type)
    scope.merge(types).or(scope.where(subsidy_organization_types: { id: nil }))
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

    merge(where(end_to: Date.today..).or(where(end_to: nil)))
  }
  scope :search_with_business_category, ->(business_category_keys) { # "seizo|kensetsu" のような形で受け取る
    return if business_category_keys.blank?

    scope = left_joins(:subsidy_business_categories)
    categories = SubsidyBusinessCategory.where(business_category: business_category_keys.to_s.split('|'))
    scope.merge(categories).or(scope.where(subsidy_business_categories: { id: nil }))
  }
  scope :search_with_employee, ->(total_employee) {
    return if total_employee.blank?

    merge(
      where('? between total_employee_min and total_employee_max', total_employee)
      .or(
        where(total_employee_min: ..total_employee).where(total_employee_max: nil)
      ).or(
        where(total_employee_min: nil).where(total_employee_max: total_employee..)
      ).or(
        where(total_employee_min: nil).where(total_employee_max: nil)
      )
    )
  }
  scope :in_years_of_establishment, ->(founding_date) {
    return if founding_date.blank?

    merge(
      where('start_from > date_add(?, interval years_of_establishment year)', founding_date.to_date)
      .or(where(years_of_establishment: nil))
    )
  }
  scope :search_with_capital, ->(capital) {
    return if capital.blank?

    merge(
      where('? between capital_min and capital_max', capital)
      .or(
        where(capital_min: ..capital).where(capital_max: nil)
      ).or(
        where(capital_min: nil).where(capital_max: capital..)
      ).or(
        where(capital_min: nil).where(capital_max: nil)
      )
    )
  }
  scope :search_with_annual_sales, ->(annual_sales) {
    return if annual_sales.blank?

    merge(
      where('? between annual_sales_min and annual_sales_max', annual_sales)
      .or(
        where(annual_sales_min: ..annual_sales).where(annual_sales_max: nil)
      ).or(
        where(annual_sales_min: nil).where(annual_sales_max: annual_sales..)
      ).or(
        where(annual_sales_min: nil).where(annual_sales_max: nil)
      )
    )
  }
  scope :admin_filter, ->(search_params) {
    publishing_filter(search_params[:publishing_code])
      .end_after(search_params[:end_after])
      .search_by_keyword(search_params[:keyword])
  }
  scope :publishing_filter, ->(code) {
    case code
    when 'published'
      where(publishing_code: 'published')
    when 'editing'
      where(publishing_code: 'editing')
    when 'archived'
      where(publishing_code: 'archived')
    end
  }
  scope :end_after, ->(date) {
    return if date.blank?

    where('end_to >= ?', date.to_date)
  }
  scope :favorite_by, ->(user) {
    joins(:user_favorite_subsidies).where(
      user_favorite_subsidies: { user_id: user.id }
    )
  }

  def organization_types
    subsidy_organization_types.map do |subsidy_organization_type|
      OrganizationType.to_option(subsidy_organization_type.organization_type)
    end
  end

  def business_categories
    subsidy_business_categories.map do |subsidy_business_category|
      BusinessCategory.to_option(subsidy_business_category.business_category)
    end
  end

  def keywords
    subsidy_keywords.map { |sk| sk.keyword.content }
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
