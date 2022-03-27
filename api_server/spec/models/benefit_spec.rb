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
require 'rails_helper'

RSpec.describe Benefit, type: :model do
  describe '#create' do
    it do
      expect(create(:benefit)).to be_present
    end
  end

  describe 'search_with_household_income' do
    subject { Benefit.search_with_household_income(household_income) }

    context 'household_income_fromとhousehold_income_toが両方とも指定されている場合' do
      let(:household_income) { 140 }
      let!(:target_record) { create(:benefit, household_income_to: 200, household_income_from: 50) }
      let!(:not_target_record) { create(:benefit, household_income_to: 2000, household_income_from: 500) }

      it '範囲内のbenefitが抽出される' do
        expect(subject).to include(target_record)
      end
      it '範囲外のsubjectは抽出されない' do
        expect(subject).not_to include(not_target_record)
      end
    end

    context 'household_income_toのみ指定されている場合' do
      let!(:target_record) { create(:benefit, household_income_to: 200, household_income_from: nil) }

      context '範囲内である場合' do
        let(:household_income) { 140 }

        it '範囲内のbenefitが抽出される' do
          expect(subject).to include(target_record)
        end
      end
      context '範囲外である場合' do
        let(:household_income) { 500 }

        it '抽出されない' do
          expect(subject).not_to include(target_record)
        end
      end
    end
    context 'household_income_fromのみ指定されている場合' do
      let!(:target_record) { create(:benefit, household_income_to: nil, household_income_from: 200) }

      context '範囲内である場合' do
        let(:household_income) { 300 }

        it '範囲内のbenefitが抽出される' do
          expect(subject).to include(target_record)
        end
      end
      context '範囲外である場合' do
        let(:household_income) { 100 }

        it '抽出されない' do
          expect(subject).not_to include(target_record)
        end
      end
    end
    context 'いずれの指定もない場合' do
      let!(:target_record) { create(:benefit, household_income_to: nil, household_income_from: nil) }
      let(:household_income) { 300 }

      it '抽出される' do
        expect(subject).to include(target_record)
      end
    end
  end
end
