# == Schema Information
#
# Table name: subsidy_cities
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  city_id    :bigint           not null
#  subsidy_id :bigint           not null
#
# Indexes
#
#  index_subsidy_cities_on_city_id                 (city_id)
#  index_subsidy_cities_on_subsidy_id              (subsidy_id)
#  index_subsidy_cities_on_subsidy_id_and_city_id  (subsidy_id,city_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (subsidy_id => subsidies.id)
#
FactoryBot.define do
  factory :subsidy_city do
    association(:subsidy)
    association(:city)
  end
end
