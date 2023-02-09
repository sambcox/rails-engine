class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from BadDataError, with: :render_bad_data

  def render_not_found(error)
    render json: ErrorSerializer.serialize(Error.new(error)), status: :not_found
  end

  def render_bad_data(error)
    render json: ErrorSerializer.serialize(Error.new(error)), status: :bad_request
  end
end
