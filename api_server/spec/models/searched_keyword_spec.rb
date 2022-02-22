# == Schema Information
#
# Table name: searched_keywords
#
#  id         :bigint           not null, primary key
#  content    :string(255)
#  hit_count  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  keyword_id :bigint
#  user_id    :bigint           not null
#
# Indexes
#
#  index_searched_keywords_on_keyword_id  (keyword_id)
#  index_searched_keywords_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe SearchedKeyword, type: :model do
  describe '#create' do
    it do
      expect(create(:searched_keyword)).to be_present
    end
  end
end
