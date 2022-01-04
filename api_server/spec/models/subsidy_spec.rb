# == Schema Information
#
# Table name: subsidies
#
#  id         :bigint           not null, primary key
#  title      :string(255)      not null
#  url        :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Subsidy, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
