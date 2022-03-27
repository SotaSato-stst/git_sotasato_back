# == Schema Information
#
# Table name: benefits
#
#  id                    :bigint           not null, primary key
#  age_from              :integer
#  age_to                :integer
#  application_detail    :text(65535)      not null
#  end_date              :date
#  for_disabled          :boolean          default(FALSE), not null
#  for_elderly_care      :boolean          default(FALSE), not null
#  for_welfare           :boolean          default(FALSE), not null
#  for_widow             :boolean          default(FALSE), not null
#  household_income_from :integer
#  household_income_to   :integer
#  price_detail          :text(65535)      not null
#  publishing_code       :string(255)      not null
#  target_detail         :text(65535)      not null
#  title                 :string(255)      not null
#  url                   :text(65535)      not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  city_id               :bigint
#  prefecture_id         :bigint
#
# Indexes
#
#  index_benefits_on_city_id          (city_id)
#  index_benefits_on_prefecture_id    (prefecture_id)
#  index_benefits_on_publishing_code  (publishing_code)
#  index_benefits_on_url              (url) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (prefecture_id => prefectures.id)
#
class Benefit < ApplicationRecord
  belongs_to :prefecture, optional: true
  belongs_to :city, optional: true

  enum publishing_code: { published: 'published', editing: 'editing', archived: 'archived' }

  validates :title, presence: { message: 'は必須項目です' }
  validates :url, presence: { message: 'は必須項目です' }
  validates :target_detail, presence: { message: 'は必須項目です' }
  validates :price_detail, presence: { message: 'は必須項目です' }
  validates :application_detail, presence: { message: 'は必須項目です' }
  validates :publishing_code, presence: { message: 'は必須項目です' }

  scope :published, -> { where(publishing_code: 'published') }
  scope :editing, -> { where(publishing_code: 'editing') }
  scope :index_loading, -> {
    includes(:prefecture, :city)
  }

  scope :scope_by_adress, ->(prefecture_id, city_id) {
    published
      .in_application_period(true)
      .search_with_prefecture(prefecture_id)
      .search_with_city(city_id)
  }

  scope :scope_by_family, ->(family) {
    published
      .in_application_period(true)
      .search_with_prefecture(family.prefecture_id)
      .search_with_city(family.city_id)
      .search_with_household_income(family.household_income)
      .search_with_age(family.members.map(&:age))
  }

  scope :in_application_period, ->(checked) {
    return unless ActiveModel::Type::Boolean.new.cast(checked)

    merge(where(end_date: Date.today..).or(where(end_date: nil)))
  }

  scope :search_with_prefecture, ->(prefecture_id) {
    return if prefecture_id.blank?

    merge(where(prefecture_id: prefecture_id).or(where(prefecture_id: nil)))
  }

  scope :search_with_city, ->(city_id) {
    return if city_id.blank?

    merge(where(city_id: city_id).or(where(city_id: nil)))
  }

  scope :search_with_household_income, ->(household_income) {
    return if household_income.blank?

    merge(
      where('? between household_income_from and household_income_to', household_income)
      .or(
        where(household_income_from: ..household_income).where(household_income_to: nil)
      ).or(
        where(household_income_from: nil).where(household_income_to: household_income..)
      ).or(
        where(household_income_from: nil).where(household_income_to: nil)
      )
    )
  }

  scope :search_with_age, ->(age) {
    return if age.blank?

    merge(
      where('? between age_from and age_to', age)
      .or(
        where(age_from: ..age_from).where(age_to: nil)
      ).or(
        where(age_from: nil).where(age_to: age..)
      ).or(
        where(age_from: nil).where(age_to: nil)
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

    where('end_date >= ?', date.to_date).or(where(end_date: nil))
  }
  scope :search_by_keyword, ->(keyword) {
    return if keyword.blank?

    merge(where('title like ?', "%#{keyword}%"))
  }

  scope :admin_sort, ->(code) {
    case code
    when 'end'
      order(end_to: :asc)
    end
  }
end
