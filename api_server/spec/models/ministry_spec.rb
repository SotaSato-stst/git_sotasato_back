# == Schema Information
#
# Table name: ministries
#
#  id         :bigint           not null, primary key
#  logo_url   :string(255)      default(""), not null
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ministries_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe Ministry, type: :model do
  describe '#crate' do
    it do
      expect(create(:ministry)).to be_present
    end
  end
end
