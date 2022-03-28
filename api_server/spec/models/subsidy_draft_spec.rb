# == Schema Information
#
# Table name: subsidy_drafts
#
#  id                :bigint           not null, primary key
#  archived          :boolean          default(FALSE), not null
#  for_benefit       :boolean          default(FALSE), not null
#  source_url_domain :string(255)      not null
#  supplier_type     :string(255)
#  title             :string(255)      not null
#  url               :text(65535)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  assignee_id       :bigint
#  city_id           :bigint
#  ministry_id       :bigint
#  prefecture_id     :bigint
#
# Indexes
#
#  index_subsidy_drafts_on_assignee_id    (assignee_id)
#  index_subsidy_drafts_on_city_id        (city_id)
#  index_subsidy_drafts_on_ministry_id    (ministry_id)
#  index_subsidy_drafts_on_prefecture_id  (prefecture_id)
#
# Foreign Keys
#
#  fk_rails_...  (assignee_id => users.id)
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (ministry_id => ministries.id)
#  fk_rails_...  (prefecture_id => prefectures.id)
#
require 'rails_helper'

RSpec.describe SubsidyDraft, type: :model do
  describe '#create' do
    it do
      expect(create(:subsidy_draft)).to be_present
    end
  end
end
