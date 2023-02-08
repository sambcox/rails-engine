class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    set_item
    return if @item == nil
    render json: ItemSerializer.new(@item)
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render json: ErrorSerializer.unprocessable(item.errors), status: :unprocessable_entity
    end
  end

  def update
    set_item
    return if @item == nil
    @item.update(item_params)
    if @item.save
      render json: ItemSerializer.new(@item)
    else
      render json: ErrorSerializer.unprocessable(@item.errors), status: :not_found
    end
  end

  def destroy
    set_item
    return if @item == nil
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
    if Item.exists?(id: params[:id])
      @item = Item.find(params[:id])
    else
      return render json: ErrorSerializer.bad_data, status: :not_found
    end
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end