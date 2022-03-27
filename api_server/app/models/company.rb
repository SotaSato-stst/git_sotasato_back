# == Schema Information
#
# Table name: companies
#
#  id                :bigint           not null, primary key
#  adress            :string(255)
#  annual_sales      :bigint
#  business_scale    :string(255)
#  capital           :bigint
#  founding_date     :date
#  name              :string(255)      not null
#  organization_type :string(255)      default(NULL), not null
#  total_employee    :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  city_id           :bigint           not null
#  prefecture_id     :bigint           not null
#
# Indexes
#
#  index_companies_on_city_id        (city_id)
#  index_companies_on_prefecture_id  (prefecture_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (prefecture_id => prefectures.id)
#
class Company < ApplicationRecord
  belongs_to :prefecture
  belongs_to :city
  has_many :company_business_categories, dependent: :destroy
  # has_many :user_companies, dependent: :destroy
  has_many :users, dependent: :destroy # , through: :user_companies

  enum organization_type: OrganizationType.enum_hash
  enum business_scale: { small_business: 'small_business', small_and_medium: 'small_and_medium', large: 'large' }

  def business_categories
    company_business_categories.map do |company_business_category|
      BusinessCategory.to_option(company_business_category.business_category)
    end
  end

  def business_category_keys
    company_business_categories.map(&:business_category)
  end
end
