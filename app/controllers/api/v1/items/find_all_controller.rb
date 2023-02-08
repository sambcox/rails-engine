class Api::V1::Items::FindAllController < ApplicationController
  def index
    if params[:min_price]
      return render json: ErrorSerializer.bad_data, status: :bad_request if params[:min_price].to_f < 0
    elsif params[:max_price]
      return render json: ErrorSerializer.bad_data, status: :bad_request if params[:max_price].to_f < 0
    end

    if (params[:name] && params[:name] != '') && (!params[:min_price] && !params[:max_price])
      set_items_by_name
      render json: ItemSerializer.new(@items)
    elsif (params[:min_price] || params[:max_price]) && (params[:min_price] != '' && params[:max_price] != '') && !params[:name]
      set_items_by_price
      render json: ItemSerializer.new(@items)
    else
      render json: ErrorSerializer.bad_data, status: :bad_request
    end
  end

  private

  def set_items_by_name
    @items = Item.find_all_by_name(params[:name])
  end

  def set_items_by_price
    @items = Item.find_all_by_price(params[:min_price], params[:max_price])
  end
end