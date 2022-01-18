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
