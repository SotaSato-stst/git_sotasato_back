require 'rails_helper'

RSpec.describe 'OrganizationTypes API', type: :request do
  describe 'GET /organization_types' do
    let(:user) { create(:user) }
    let(:organization_types) { ['kojin'] }
    let!(:subsidy) do
      create(
        :subsidy,
        organization_types: organization_types,
      )
    end
    subject { get '/subsidies' }

    before do
      sign_in_with(user)
    end

    it 'returns correct response' do
      subject
      expect(json['subsidies'][0]['organization_types']).to eq [{ 'key' => 'kojin', 'name' => '個人事業主' }]
    end
  end
end
