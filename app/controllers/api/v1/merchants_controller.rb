class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(set_merchant)
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:id])
  end
end