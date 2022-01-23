class CompaniesController < ApplicationController
  def index
    @companies = Company.all.includes(:prefecture)
  end

  def show
    @company = Company.find(params[:id])
  end
end
