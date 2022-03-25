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
#  index_benefits_on_city_id        (city_id)
#  index_benefits_on_prefecture_id  (prefecture_id)
#  index_benefits_on_url            (url) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (prefecture_id => prefectures.id)
#
class Benefit < ApplicationRecord
  belongs_to :prefecture, optional: true
  belongs_to :city, optional: true
end
