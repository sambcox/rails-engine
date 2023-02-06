class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(set_item)
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end
end