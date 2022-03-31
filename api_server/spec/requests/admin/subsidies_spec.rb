require 'rails_helper'

RSpec.describe 'Admin Subsidies', type: :request do
  let(:sign_in_user) { create(:user, :admin) }

  before do
    sign_in_with(sign_in_user)
  end

  let(:ministry) { create(:ministry, name: '経済産業省') }
  let!(:subsidy) do
    create(
      :subsidy,
      title: 'ものづくり補助金',
      url: 'https://portal.monodukuri-hojo.jp/',
      ministry: ministry,
      start_from: '2022-01-12',
      end_to: '2023-01-15',
      publishing_code: 'published',
      price_max: 30,
      support_ratio_min: '20',
      support_ratio_max: '40',
      level: 4,
      detail: '詳細文章',
      subsidy_category: 'hojo',
      supplier_type: 'ministry',
      ranking_score: 50,
      total_employee_max: 500,
      total_employee_min: 200,
      capital_max: 60_000_000,
      capital_min: 20_000_000,
      years_of_establishment: 10,
      annual_sales_max: 1_000_000_000,
      annual_sales_min: 500_000_000,
      catch_copy: '設備投資を応援！'
    )
  end

  describe 'GET /subsidies' do
    subject { get '/admin/subsidies' }

    it 'returns object' do
      subject
      expect(json['subsidies'][0]['title']).to eq 'ものづくり補助金'
      expect(json['subsidies'][0]['url']).to eq 'https://portal.monodukuri-hojo.jp/'
      expect(json['subsidies'][0]['ministry']['name']).to eq '経済産業省'
      expect(json['subsidies'][0]['start_from']).to eq '2022-01-12'
      expect(json['subsidies'][0]['end_to']).to eq '2023-01-15'
      expect(json['subsidies'][0]['publishing_code']).to eq 'published'
      expect(json['subsidies'][0]['price_max']).to eq 30
      expect(json['subsidies'][0]['support_ratio_min']).to eq '20'
      expect(json['subsidies'][0]['support_ratio_max']).to eq '40'
      expect(json['subsidies'][0]['level']).to eq 4
      expect(json['subsidies'][0]['detail']).to eq '詳細文章'
      expect(json['subsidies'][0]['subsidy_category']).to eq 'hojo'
      expect(json['subsidies'][0]['supplier_type']).to eq 'ministry'
      expect(json['subsidies'][0]['ranking_score']).to eq 50
      expect(json['subsidies'][0]['total_employee_max']).to eq 500
      expect(json['subsidies'][0]['total_employee_min']).to eq 200
      expect(json['subsidies'][0]['capital_max']).to eq 60_000_000
      expect(json['subsidies'][0]['capital_min']).to eq 20_000_000
      expect(json['subsidies'][0]['years_of_establishment']).to eq 10
      expect(json['subsidies'][0]['annual_sales_max']).to eq 1_000_000_000
      expect(json['subsidies'][0]['annual_sales_min']).to eq 500_000_000
      expect(json['subsidies'][0]['catch_copy']).to eq '設備投資を応援！'
    end
  end

  describe 'GET /subsidies/:id' do
    subject { get "/admin/subsidies/#{subsidy.id}" }

    it 'returns object' do
      subject
      expect(json['title']).to eq 'ものづくり補助金'
      expect(json['url']).to eq 'https://portal.monodukuri-hojo.jp/'
      expect(json['ministry']['name']).to eq '経済産業省'
      expect(json['start_from']).to eq '2022-01-12'
      expect(json['end_to']).to eq '2023-01-15'
      expect(json['publishing_code']).to eq 'published'
      expect(json['price_max']).to eq 30
      expect(json['support_ratio_min']).to eq '20'
      expect(json['support_ratio_max']).to eq '40'
      expect(json['level']).to eq 4
      expect(json['detail']).to eq '詳細文章'
      expect(json['subsidy_category']).to eq 'hojo'
      expect(json['supplier_type']).to eq 'ministry'
      expect(json['ranking_score']).to eq 50
      expect(json['total_employee_max']).to eq 500
      expect(json['total_employee_min']).to eq 200
      expect(json['capital_max']).to eq 60_000_000
      expect(json['capital_min']).to eq 20_000_000
      expect(json['years_of_establishment']).to eq 10
      expect(json['annual_sales_max']).to eq 1_000_000_000
      expect(json['annual_sales_min']).to eq 500_000_000
      expect(json['catch_copy']).to eq '設備投資を応援！'
    end
  end
end
