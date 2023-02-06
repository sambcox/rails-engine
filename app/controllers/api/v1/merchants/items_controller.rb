class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    set_merchant
    render json: ItemSerializer.new(@merchant.items)
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end