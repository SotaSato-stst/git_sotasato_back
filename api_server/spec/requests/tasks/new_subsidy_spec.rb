require 'rails_helper'

RSpec.describe 'Tasks NewSubsidy API', type: :request do
  before do
    service = instance_double(NewSubsidyService)
    allow(NewSubsidyService).to receive(:new).with(Date.today).and_return(service)
    allow(service).to receive(:execute!).and_return(true)
  end

  describe 'GET /tasks/new_subsidy' do
    subject { get '/tasks/new_subsidy', headers: { 'X-Appengine-Cron' => true } }

    it 'returns correct response' do
      subject
      expect(response.status).to eq 200
    end
  end
end
