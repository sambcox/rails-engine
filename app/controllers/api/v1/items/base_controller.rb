class Api::V1::Items::BaseController < ApplicationController
  rescue_from ActiveRecord::StatementInvalid, with: :invalid_string

  def invalid_string(error)
    render json: ErrorSerializer.serialize(Error.new(error)), status: :bad_request
  end
end