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
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (prefecture_id => prefectures.id)
#
FactoryBot.define do
  factory :company do
    name { '池垣物産'  }
    city { association(:city) }
    prefecture { city.prefecture }
    adress { '千歳市30-2' }
    capital { '5040404' }
    total_employee { '30' }
  end
end
