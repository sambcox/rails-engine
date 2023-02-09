class Api::V1::Items::FindAllController < Api::V1::Items::BaseController
  def index
    return render_error("Query must be provided") unless params[:name] || params[:min_price] || params[:max_price]
    return render_error("Name must be provided") if params[:name] == ''
    return render_error("Price parameter cannot be below zero") if (params[:min_price].to_f < 0 || params[:max_price].to_f < 0)
    return render_error("Please provide either name or price parameters, not both") if params[:name] && (params[:min_price] || params[:max_price])

    set_items
    render_items
  end

  private

  def render_error(message)
    render json: ErrorSerializer.bad_data(Error.new(message)), status: :bad_request
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
