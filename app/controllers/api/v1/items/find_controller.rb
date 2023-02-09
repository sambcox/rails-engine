class Api::V1::Items::FindController < Api::V1::Items::BaseController
  def index
    params_valid?

    set_item
    render_item
  end

  private

  def params_valid?
    raise BadDataError.new("Query must be provided") unless params[:name] || params[:min_price] || params[:max_price]
    raise BadDataError.new("Name must be provided") if params[:name] == ''
    raise BadDataError.new("Price parameter cannot be below zero") if (params[:min_price].to_f < 0 || params[:max_price].to_f < 0)
    raise BadDataError.new("Please provide either name or price parameters, not both") if params[:name] && (params[:min_price] || params[:max_price])
    raise BadDataError.new('Minimum price must be less than maximum price') if (params[:min_price] && params[:max_price]) && (params[:min_price].to_f > params[:max_price].to_f)
  end

  def set_item
    if params[:name]
      set_item_by_name
    elsif params[:min_price] || params[:max_price]
      set_item_by_price
    end
  end

  def render_item
    if @item.nil?
      render json: ErrorSerializer.no_data
    else
      render json: ItemSerializer.new(@item)
    end
  end

  def set_item_by_name
    @item = Item.find_by_name(params[:name])
  end

  def set_item_by_price
    @item = Item.find_by_price(params[:min_price], params[:max_price])
  end
end