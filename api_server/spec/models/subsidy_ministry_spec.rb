# == Schema Information
#
# Table name: subsidy_ministries
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ministry_id :bigint           not null
#  subsidy_id  :bigint           not null
#
# Indexes
#
#  index_subsidy_ministries_on_ministry_id                 (ministry_id)
#  index_subsidy_ministries_on_subsidy_id                  (subsidy_id)
#  index_subsidy_ministries_on_subsidy_id_and_ministry_id  (subsidy_id,ministry_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (ministry_id => ministries.id)
#  fk_rails_...  (subsidy_id => subsidies.id)
#
require 'rails_helper'

RSpec.describe SubsidyMinistry, type: :model do
  describe '#create' do
    it do
      expect(create(:subsidy_ministry, :with_association)).to be_present
    end
  end
end
