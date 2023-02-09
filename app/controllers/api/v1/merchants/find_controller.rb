class Api::V1::Merchants::FindController < ApplicationController
  def index
    if params[:name] && params[:name] != ''
      set_merchant
      if @merchant.nil?
        render json: ErrorSerializer.no_data
      else
        render json: MerchantSerializer.new(@merchant)
      end
    else
      raise BadDataError.new('Parameter must be present')
    end
  end

  private

  def set_merchant
    @merchant = Merchant.find_by_name(params[:name])
  end
end