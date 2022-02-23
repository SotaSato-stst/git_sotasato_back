# == Schema Information
#
# Table name: subsidy_organization_types
#
#  id                :bigint           not null, primary key
#  organization_type :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  subsidy_id        :bigint           not null
#
# Indexes
#
#  index_subsidy_organization_types_on_subsidy_id  (subsidy_id)
#
# Foreign Keys
#
#  fk_rails_...  (subsidy_id => subsidies.id)
#
require 'rails_helper'

RSpec.describe SubsidyOrganizationType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
