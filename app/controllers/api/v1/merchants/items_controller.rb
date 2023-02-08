class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    set_merchant
    return if @merchant.nil?
    render json: ItemSerializer.new(@merchant.items)
  end

  private

  def set_merchant
    if Merchant.exists?(id: params[:merchant_id])
      @merchant = Merchant.find(params[:merchant_id])
    else
      render json: ErrorSerializer.bad_data, status: :not_found
    end
  end
end