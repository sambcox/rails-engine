class Api::V1::Items::FindAllController < Api::V1::Items::BaseController
  def index
    params_valid?

    set_items
    render_items
  end

  private

  def params_valid?
    raise BadDataError.new("Query must be provided") unless params[:name] || params[:min_price] || params[:max_price]
    raise BadDataError.new("Name must be provided") if params[:name] == ''
    raise BadDataError.new("Price parameter cannot be below zero") if (params[:min_price].to_f < 0 || params[:max_price].to_f < 0)
    raise BadDataError.new("Please provide either name or price parameters, not both") if params[:name] && (params[:min_price] || params[:max_price])
    raise BadDataError.new('Minimum price must be less than maximum price') if (params[:min_price] && params[:max_price]) && (params[:min_price].to_f > params[:max_price].to_f)
  end

  def set_items
    if params[:name]
      set_items_by_name
    elsif params[:min_price] || params[:max_price]
      set_items_by_price
    end
  end

  def render_items
    render json: ItemSerializer.new(@items)
  end

  def set_items_by_name
    @items = Item.find_all_by_name(params[:name])
  end

  def set_items_by_price
    @items = Item.find_all_by_price(params[:min_price], params[:max_price])
  end
end
