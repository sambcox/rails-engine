class Api::V1::Merchants::FindAllController < ApplicationController
  def index
    if params[:name] && params[:name] != ''
      set_merchant
      render json: MerchantSerializer.new(@merchant)
    else
      raise BadDataError.new('Parameter must be present')
    end
  end

  private

  def set_merchant
    @merchant = Merchant.find_all_by_name(params[:name])
  end
end