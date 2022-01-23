# == Schema Information
#
# Table name: companies
#
#  id             :bigint           not null, primary key
#  adress         :string(255)
#  business_scale :string(255)
#  capital        :integer
#  name           :string(255)      not null
#  total_employee :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  city_id        :bigint           not null
#  prefecture_id  :bigint           not null
#
# Indexes
#
#  index_companies_on_city_id        (city_id)
#  index_companies_on_prefecture_id  (prefecture_id)
#
class Company < ApplicationRecord
  belongs_to :prefecture
  belongs_to :city
  enum business_scale: { small_business: 'small_business', small_and_medium: 'small_and_medium', large: 'large' }
end
