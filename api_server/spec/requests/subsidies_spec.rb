require 'rails_helper'

RSpec.describe 'Subsidies API', type: :request do
  let(:ministry) { create(:ministry, name: '経済産業省') }
  let!(:subsidy) do
    create(:subsidy, title: 'ものづくり補助金', url: 'https://portal.monodukuri-hojo.jp/', ministry: ministry,
                     start_from: '2022-01-12', end_to: '2023-01-15', publishing_code: 'published', price_max: 30, support_ratio_min: '20', 
                     support_ratio_max: '40', level: 4, detail: '詳細文章', target_detail: '対象の説明文', subsidy_category: 'hojo', supplier_type: 'ministry')
  end

  describe 'GET /subsidies' do
    subject { get '/subsidies' }

    it 'returns correct response' do
      subject
      assert_response_schema_confirm(200)
    end

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
      expect(json['subsidies'][0]['target_detail']).to eq '対象の説明文'
      expect(json['subsidies'][0]['subsidy_category']).to eq 'hojo'
      expect(json['subsidies'][0]['supplier_type']).to eq 'ministry'
    end
  end

  describe 'GET /subsidies/:id' do
    subject { get "/subsidies/#{subsidy.id}" }

    it 'returns correct response' do
      subject
      assert_response_schema_confirm(200)
    end

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
      expect(json['target_detail']).to eq '対象の説明文'
      expect(json['subsidy_category']).to eq 'hojo'
      expect(json['supplier_type']).to eq 'ministry'
    end
  end
end
