class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    set_item
    render json: ItemSerializer.new(@item)
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render json: ErrorSerializer.serialize(Error.new(item.errors)), status: :unprocessable_entity
    end
  end

  def update
    set_item
    @item.update(item_params)
    if @item.save
      render json: ItemSerializer.new(@item)
    else
      render json: ErrorSerializer.serialize(Error.new(@item.errors)), status: :not_found
    end
  end

  def destroy
    set_item
    destroy_invoice_items
    render json: ItemSerializer.new(@item.destroy)
  end

  private

  def destroy_invoice_items
    @item.invoices.each do |invoice|
      if invoice.invoice_items.count <= 1
        invoice.destroy
      end
    end
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end