module Business
  class OrganizationTypesController < BaseController
    def index
      render json: { organization_types: OrganizationType.to_options }
    end
  end
end
