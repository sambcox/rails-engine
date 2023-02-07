class Api::V1::Merchants::FindController < ApplicationController
  def index
    if params[:name] && params[:name] != ''
      set_merchant
      render json: MerchantSerializer.new(@merchant)
    else
      render json: ErrorSerializer.bad_data, status: :not_found
    end
  end

  private

  def set_merchant
    @merchant = Merchant.find_by_name(params[:name])
  end
end