module Admin
  class SubsidiesController < ApplicationController
    def index
      # TODO
    end

    def show
      @subsidy = Subsidy.find(params[:id])
    end

    def create
      @subsidy = Subsidy.new(create_params)
      set_association

      if @subsidy.save
        SubsidyDraft.find_by(url: params[:url]).destroy
        render :show, status: 201
      else
        render json: { message: '入力内容を確認してください', errors: @subsidy.errors.full_messages }, status: 400
      end
    end

    private

    def create_params
      params.permit(
        :title,
        :publishing_code,
        :url,
        :subsidy_category,
        :supplier_type,
        :start_from,
        :end_to,
        :price_max,
        :support_ratio_min,
        :support_ratio_max,
        :level,
        :detail,
        :target_detail
      )
    end

    def set_association
      @subsidy.ministry = Ministry.where(id: params[:ministry_id]).first
      @subsidy.prefecture = Prefecture.where(id: params[:prefecture_id]).first
      @subsidy.city = City.where(id: params[:city_id]).first
    end
  end
end
