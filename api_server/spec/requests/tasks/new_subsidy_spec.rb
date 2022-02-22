require 'rails_helper'

RSpec.describe 'Tasks NewSubsidy API', type: :request do
  before do
    service = instance_double(NewSubsidyService)
    allow(NewSubsidyService).to receive(:new).with(Date.today).and_return(service)
    allow(service).to receive(:execute!).and_return(true)
    slack_service = instance_double(SlackService)
    allow(SlackService).to receive(:new).and_return(slack_service)
    allow(slack_service).to receive(:post_new_subsidy_draft).and_return(true)
    allow(slack_service).to receive(:post_new_subsidies_count).and_return(true)
  end

  describe 'GET /tasks/new_subsidy' do
    subject { get '/tasks/new_subsidy', headers: { 'X-Appengine-Cron' => true } }

    it 'returns correct response' do
      subject
      expect(response.status).to eq 200
    end
  end
end
