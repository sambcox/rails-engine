class Api::V1::Items::MerchantController < ApplicationController
  def index
    set_item
    render json: MerchantSerializer.new(@item.merchant)
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end
end