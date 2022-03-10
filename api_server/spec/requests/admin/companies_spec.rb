require 'rails_helper'

RSpec.describe 'Admin Companies', type: :request do
  let(:sign_in_user) { create(:user, :admin, company: company) }
  let(:prefecture) { create(:prefecture, name: '大阪府') }
  let(:city) { create(:city, id: 1) }
  let!(:company) do
    create(
      :company,
      name: '池垣株式会社',
      prefecture: prefecture,
      city: city,
      adress: 'つくば市天久保3丁目12-34',
      capital: 200_000,
      total_employee: 200,
      founding_date: '2020-04-24',
      annual_sales: 10_000_000,
      organization_type: 'kabu'
    )
  end

  before do
    sign_in_with(sign_in_user)
  end

  describe 'GET /companies' do
    subject { get '/admin/companies' }

    it 'returns correct response' do
      subject
      assert_response_schema_confirm(200)
    end

    it 'returns object' do
      subject
      expect(json['companies'][0]['name']).to eq '池垣株式会社'
      expect(json['companies'][0]['prefecture']['name']).to eq '大阪府'
      expect(json['companies'][0]['city']['id']).to eq 1
      expect(json['companies'][0]['adress']).to eq 'つくば市天久保3丁目12-34'
      expect(json['companies'][0]['capital']).to eq 200_000
      expect(json['companies'][0]['total_employee']).to eq 200
      expect(json['companies'][0]['founding_date']).to eq '2020-04-24'
      expect(json['companies'][0]['annual_sales']).to eq 10_000_000
      expect(json['companies'][0]['organization_type']).to eq 'kabu'
    end
  end

  describe 'GET /companies/:id' do
    subject { get "/admin/companies/#{company.id}" }

    it 'returns correct response' do
      subject
      assert_response_schema_confirm(200)
    end

    it 'returns object' do
      subject
      expect(json['name']).to eq '池垣株式会社'
      expect(json['prefecture']['name']).to eq '大阪府'
      expect(json['city']['id']).to eq 1
      expect(json['adress']).to eq 'つくば市天久保3丁目12-34'
      expect(json['capital']).to eq 200_000
      expect(json['total_employee']).to eq 200
      expect(json['founding_date']).to eq '2020-04-24'
      expect(json['annual_sales']).to eq 10_000_000
      expect(json['organization_type']).to eq 'kabu'
    end
  end

  describe 'POST /companies' do
    subject { post '/admin/companies', params: params }

    let(:params) do
      {
        name: '会社名',
        adress: '住所',
        capital: 100_000,
        total_employee: 1000,
        prefecture_id: prefecture.id,
        city_id: city.id,
        organization_types: ['kojin'],
        business_categories: ['it'],
        annual_sales: 10_000_000,
        founding_date: '2020-04-24'

      }
    end

    it 'creates a record' do
      subject
      assert_response_schema_confirm(201)
    end
  end

  describe 'PUT /companies/:id' do
    subject { put "/admin/companies/#{company.id}", params: params }

    let(:company) { create(:company) }
    let(:params) do
      {
        name: '会社名',
        adress: '住所',
        capital: 100_000,
        total_employee: 1000,
        prefecture_id: prefecture.id,
        city_id: city.id,
        business_categories: ['it'],
        organization_types: ['kojin'],
        annual_sales: 10_000_000,
        founding_date: '2020-04-24'
      }
    end

    it 'updates a record' do
      subject
      assert_response_schema_confirm(200)
    end
  end
end
