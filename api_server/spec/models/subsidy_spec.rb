# == Schema Information
#
# Table name: subsidies
#
#  id                     :bigint           not null, primary key
#  annual_sales_max       :bigint
#  annual_sales_min       :bigint
#  capital_max            :bigint
#  capital_min            :integer
#  detail                 :text(65535)      not null
#  end_to                 :date
#  level                  :integer
#  price_max              :bigint
#  publishing_code        :string(255)      not null
#  ranking_score          :integer
#  start_from             :date
#  subsidy_category       :string(255)
#  supplier_type          :string(255)
#  support_ratio_max      :string(255)
#  support_ratio_min      :string(255)
#  target_detail          :text(65535)      not null
#  title                  :string(255)      not null
#  total_employee_max     :integer
#  total_employee_min     :integer
#  url                    :text(65535)      not null
#  years_of_establishment :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_subsidies_on_price_max      (price_max)
#  index_subsidies_on_ranking_score  (ranking_score)
#  index_subsidies_on_url            (url) UNIQUE
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
    context 'when end_to = ""' do
      it 'returns false' do
        subsidy = build(:subsidy, start_from: '2021-01-01', end_to: '')
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
  describe 'in_application_period' do
    subject { Subsidy.in_application_period(checked) }

    context '一致するデータが存在するとき' do
      let(:checked) { true }
      let!(:target_record) { create(:subsidy, end_to: '2023-11-22') }
      let!(:not_target_record) { create(:subsidy, end_to: '2011-11-22') }
      it 'end_to>Date.todayのsubsidyが抽出される' do
        expect(subject).to include(target_record)
      end
      it 'end_to<Date.todayのsubsidyは抽出されない' do
        expect(subject).not_to include(not_target_record)
      end
    end
  end
  describe 'search_with_business_category' do
    subject { Subsidy.search_with_business_category(business_category_keys) }
    context '一致するデータが存在するとき' do
      let(:business_category_keys) { 'seizo' }
      let!(:target_record) { create(:subsidy_business_category, business_category: 'seizo') }
      let!(:not_target_record) { create(:subsidy_business_category, business_category: 'kensetsu') }

      it '業種がseizoのsubsidyが抽出される' do
        expect(subject).to include(target_record.subsidy)
      end
      it 'seizoではないsubjectは抽出されない' do
        expect(subject).not_to include(not_target_record.subsidy)
      end
    end
  end

  describe 'search_with_capital' do
    subject { Subsidy.search_with_capital(capital) }

    context 'capital_minとcapital_maxが両方とも指定されている場合' do
      let(:capital) { 140 }
      let!(:target_record) { create(:subsidy, capital_max: 200, capital_min: 50) }
      let!(:not_target_record) { create(:subsidy, capital_max: 2000, capital_min: 500) }

      it '資本金が範囲内のsubsidyが抽出される' do
        expect(subject).to include(target_record)
      end
      it '範囲外のsubjectは抽出されない' do
        expect(subject).not_to include(not_target_record)
      end
    end

    context 'capital_maxのみ指定されている場合' do
      let!(:target_record) { create(:subsidy, capital_max: 200, capital_min: nil) }

      context '範囲内である場合' do
        let(:capital) { 140 }

        it '資本金が範囲内のsubsidyが抽出される' do
          expect(subject).to include(target_record)
        end
      end
      context '範囲外である場合' do
        let(:capital) { 500 }

        it '抽出されない' do
          expect(subject).not_to include(target_record)
        end
      end
    end
    context 'capital_minのみ指定されている場合' do
      let!(:target_record) { create(:subsidy, capital_max: nil, capital_min: 200) }

      context '範囲内である場合' do
        let(:capital) { 300 }

        it '資本金が範囲内のsubsidyが抽出される' do
          expect(subject).to include(target_record)
        end
      end
      context '範囲外である場合' do
        let(:capital) { 100 }

        it '抽出されない' do
          expect(subject).not_to include(target_record)
        end
      end
    end
    context 'いずれの指定もない場合' do
      let!(:target_record) { create(:subsidy, capital_max: nil, capital_min: nil) }
      let(:capital) { 300 }

      it '抽出される' do
        expect(subject).to include(target_record)
      end
    end
  end

  describe 'search_with_employee' do
    subject { Subsidy.search_with_employee(total_employee) }
    context '一致するデータが存在するとき' do
      let(:total_employee) { 10 }
      let!(:target_record) { create(:subsidy, total_employee_max: 20, total_employee_min: 5) }
      let!(:not_target_record) { create(:subsidy, total_employee_max: 200, total_employee_min: 50) }

      it '資本金が範囲内のsubsidyが抽出される' do
        expect(subject).to include(target_record)
      end
      it '範囲外のsubjectは抽出されない' do
        expect(subject).not_to include(not_target_record)
      end
    end
  end

  describe 'search_by_keyword' do
    subject { Subsidy.search_by_keyword(keyword) }

    let(:subsidy) { create(:subsidy) }

    context 'when keyword exists' do
      before do
        keyword = create(:keyword, content: '検索単語')
        create(:subsidy_keyword, subsidy: subsidy, keyword: keyword)
      end

      let(:keyword) { '検索単語' }

      it 'returns target' do
        expect(subject).to include subsidy
      end
    end

    context 'when keyword does not exist' do
      let(:keyword) { '検索単語' }

      it 'returns none' do
        expect(subject).not_to include subsidy
      end
    end
  end

  describe 'search_by_user' do
    subject { Subsidy.search_by_user(params) }

    let(:prefecture) { create(:prefecture) }
    let(:city) { create(:city) }
    let(:city2) { create(:city) }
    let(:business_category_keys) { %w[seizo] }
    let(:params) do
      {
        prefecture_id: prefecture.id,
        city_ids: [city.id].join('|'),
        in_application_period: false,
        business_category_keys: business_category_keys.join('|')
      }
    end

    before do
      create(:subsidy, prefecture: prefecture)
      create(:subsidy, prefecture: create(:prefecture))
      create(:subsidy, prefecture: prefecture, city: city)
      create(:subsidy, prefecture: prefecture, city: city2)
      create(:subsidy, business_categories: business_category_keys)
      create(:subsidy, business_categories: %w[gyogyo])
    end

    it 'includes targets' do
      expect(subject.count).to eq 3
    end
  end
end
