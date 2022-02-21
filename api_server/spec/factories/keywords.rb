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
FactoryBot.define do
  factory :keyword do
    content { 'content' }
  end
end
