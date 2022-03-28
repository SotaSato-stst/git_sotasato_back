# == Schema Information
#
# Table name: families
#
#  id               :bigint           not null, primary key
#  has_disabled     :boolean
#  has_widow        :boolean
#  household_income :integer
#  on_elderly_care  :boolean
#  on_welfare       :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  city_id          :bigint           not null
#  prefecture_id    :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_families_on_city_id        (city_id)
#  index_families_on_prefecture_id  (prefecture_id)
#  index_families_on_user_id        (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (prefecture_id => prefectures.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Family, type: :model do
  describe '#create' do
    it do
      expect(create(:family)).to be_present
    end
  end
end
