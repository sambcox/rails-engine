class Api::V1::Items::FindAllController < ApplicationController
  def index
    if params[:name] && params[:name] != ''
      set_items
      render json: ItemSerializer.new(@items)
    else
      render json: ErrorSerializer.bad_data, status: :not_found
    end
  end

  private

  def set_items
    @items = Item.find_all_by_name(params[:name])
  end
end