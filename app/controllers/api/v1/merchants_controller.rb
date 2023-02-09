class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    set_merchant
    return if @merchant.nil?
    render json: MerchantSerializer.new(@merchant)
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:id])
  end
end