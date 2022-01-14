# == Schema Information
#
# Table name: subsidies
#
#  id         :bigint           not null, primary key
#  end_to     :date
#  start_from :date             not null
#  title      :string(255)      not null
#  url        :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
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

    describe '#start_from_cannot_be_greater_than_end_to' do
      context 'when start_from > end_to' do
        it 'please true' do
          subsidy = build(:subsidy, start_from: "2002-01-22", end_to: "2012-11-22")
          expect(subsidy).to be_valid
        end
      end
    end

    context 'when start_from < end_to' do
      it 'please false' do
        subsidy = build(:subsidy, start_from: "2032-01-22", end_to: "2012-11-22")
        expect(subsidy).to be_invalid
      end
    end
  end
end
