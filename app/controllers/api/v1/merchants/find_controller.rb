class Api::V1::Merchants::FindController < ApplicationController
  def index
    set_merchant
    render json: MerchantSerializer.new(@merchant)
  end

  private

  def set_merchant
    @merchant = Merchant.find_by_name(params[:name])
  end
end