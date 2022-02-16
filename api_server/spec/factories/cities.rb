# == Schema Information
#
# Table name: cities
#
#  id            :bigint           not null, primary key
#  logo_url      :string(255)      default(""), not null
#  name          :string(255)      not null
#  url_domain    :string(255)      default(""), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  prefecture_id :bigint           not null
#
# Indexes
#
#  index_cities_on_prefecture_id  (prefecture_id)
#
# Foreign Keys
#
#  fk_rails_...  (prefecture_id => prefectures.id)
#
FactoryBot.define do
  factory :city do
    name { 'name' }
    logo_url { 'https://example.com/logo.png' }
    association(:prefecture)
  end
end
