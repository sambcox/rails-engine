class Api::V1::Items::MerchantController < ApplicationController
  def index
    set_item
    return if @item.nil?
    render json: MerchantSerializer.new(@item.merchant)
  end

  private

  def set_item
    if Item.exists?(id: params[:item_id])
      @item = Item.find(params[:item_id])
    else
      return render json: ErrorSerializer.bad_data, status: :not_found
    end
  end
end