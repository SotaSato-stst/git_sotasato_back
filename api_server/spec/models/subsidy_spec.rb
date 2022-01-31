# == Schema Information
#
# Table name: subsidies
#
#  id                :bigint           not null, primary key
#  detail            :text(65535)      not null
#  end_to            :date
#  level             :integer
#  price_max         :integer
#  publishing_code   :string(255)      not null
#  start_from        :date             not null
#  subsidy_category  :string(255)
#  supplier_type     :string(255)
#  support_ratio_max :string(255)
#  support_ratio_min :string(255)
#  target_detail     :text(65535)      not null
#  title             :string(255)      not null
#  url               :text(65535)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_subsidies_on_url  (url) UNIQUE
#
require 'rails_helper'

RSpec.describe Subsidy, type: :model do
  describe '#create' do
    it do
      expect(create(:subsidy)).to be_present
    end
  end

  describe '#start_from_cannot_be_greater_than_end_to' do
    context 'when start_from > end_to' do
      it 'returns true' do
        subsidy = build(:subsidy, start_from: '2002-01-22', end_to: '2012-11-22')
        expect(subsidy).to be_valid
      end
    end

    context 'when start_from < end_to' do
      it 'returns false' do
        subsidy = build(:subsidy, start_from: '2021-01-28', end_to: '2021-01-24')
        expect(subsidy).to be_invalid
      end
    end
    context 'when start_from = ""' do
      it 'returns true' do
        subsidy = build(:subsidy, start_from: '', end_to: '2021-01-24')
        expect(subsidy).to be_valid
      end
    end
    context 'when end_to = ""' do
      it 'returns false' do
        subsidy = build(:subsidy, start_from: '2021-01-01', end_to: '')
        expect(subsidy).to be_valid
      end
    end
    context 'when start_from = nil' do
      it 'returns false' do
        subsidy = build(:subsidy, start_from: nil, end_to: '2021-01-01')
        expect(subsidy).to be_valid
      end
    end
    context 'when end_to = nil' do
      it 'returns false' do
        subsidy = build(:subsidy, start_from: '2021-01-01', end_to: nil)
        expect(subsidy).to be_valid
      end
    end
  end
  describe 'supplier_type_must_have_association' do
    subject { subsidy.valid? }

    let(:subsidy) { build(:subsidy) }

    context 'when supplier_type = ministry' do
      before { subsidy.supplier_type = 'ministry' }

      context 'when subsidy_ministry exists' do
        let(:ministry) { create(:ministry) }

        before do
          subsidy.subsidy_ministry = build(:subsidy_ministry, subsidy: subsidy, ministry: ministry)
        end

        it 'returns true' do
          expect(subject).to be_truthy # 成功
        end
      end
      context 'when subsidy_ministry is nil' do
        it 'returns false' do
          expect(subject).to be_falsy # 失敗
        end
      end
    end
    context 'when supplier_type = prefecture' do
      before { subsidy.supplier_type = 'prefecture' }

      context 'when subsidy_prefecture exists' do
        let(:prefecture) { create(:prefecture) }

        before do
          subsidy.subsidy_prefecture = build(:subsidy_prefecture, subsidy: subsidy, prefecture: prefecture)
        end

        it 'returns true' do
          expect(subject).to be_truthy # 成功
        end
      end
      context 'when subsidy_prefecture is nil' do
        it 'returns false' do
          expect(subject).to be_falsy # 失敗
        end
      end
    end
    context 'when supplier_type = city' do
      before { subsidy.supplier_type = 'city' }

      context 'when subsidy_city exists' do
        let(:city) { create(:city) }
        let(:prefecture) { create(:prefecture) }

        before do
          subsidy.subsidy_city = build(:subsidy_city, subsidy: subsidy, city: city)
          subsidy.subsidy_prefecture = build(:subsidy_prefecture, subsidy: subsidy, prefecture: prefecture)
        end

        it 'returns true' do
          expect(subject).to be_truthy # 成功
        end
      end
      context 'when subsidy_city is nil' do
        it 'returns false' do
          expect(subject).to be_falsy # 失敗
        end
      end
      context 'when subsidy_city exists but subsidy_prefecture is nil' do
        it 'returns false' do
          expect(subject).to be_falsy # 失敗
        end
      end
    end
  end
  describe 'level_validates' do
    context 'when number<1' do
      it 'returns false' do
        subsidy = build(:subsidy, level: '0')
        expect(subsidy).to be_invalid
      end
    end

    context 'when number>5' do
      it 'returns false' do
        subsidy = build(:subsidy, level: '7')
        expect(subsidy).to be_invalid
      end
    end
    context 'when 1<number<5' do
      it 'returns true' do
        subsidy = build(:subsidy, level: '3')
        expect(subsidy).to be_valid
      end
    end
    context 'when number=空白' do
      it 'returns true' do
        subsidy = build(:subsidy, level: '')
        expect(subsidy).to be_valid
      end
    end
    context 'when number=nil' do
      it 'returns true' do
        subsidy = build(:subsidy, level: nil)
        expect(subsidy).to be_valid
      end
    end
  end
end
