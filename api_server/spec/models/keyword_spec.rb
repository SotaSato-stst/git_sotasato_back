# == Schema Information
#
# Table name: keywords
#
#  id         :bigint           not null, primary key
#  content    :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_keywords_on_content  (content) UNIQUE
#
require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe '#create' do
    it do
      expect(create(:keyword)).to be_present
    end
  end
end
