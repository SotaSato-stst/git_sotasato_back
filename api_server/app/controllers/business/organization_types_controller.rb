module Business
  class OrganizationTypesController < ApplicationController
    def index
      render json: { organization_types: OrganizationType.to_options }
    end

    private

    def controller_action_authrized?
      current_user.present?
    end
  end
end
