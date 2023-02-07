class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(set_item)
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item)
    else
      render json: ErrorSerializer.serialize(item.errors), status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end