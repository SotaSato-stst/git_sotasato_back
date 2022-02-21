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
class SearchedKeyword < ApplicationRecord
  belongs_to :keyword, optional: true
  belongs_to :user

  class << self
    def top_keywords(number)
      SearchedKeyword.group(:content).count.sort_by { |_, v| -v }.first(number).map(&:first)
    end

    def keyword_stats
      words = SearchedKeyword.group(:content).having('count(*) > 1').count.sort_by { |_, v| -v }.first(100)
      words.map do |word, count|
        {
          content: word,
          count: count
        }
      end
    end
  end
end
