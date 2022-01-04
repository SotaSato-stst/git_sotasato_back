class SubsidiesController < ApplicationController
  def index
    @subsidies = Subsidy.all
  end
end
