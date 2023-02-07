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
    if Merchant.exists?(id: params[:id])
      @merchant = Merchant.find(params[:id])
    else
      render json: ErrorSerializer.bad_data, status: :not_found
    end
  end
end