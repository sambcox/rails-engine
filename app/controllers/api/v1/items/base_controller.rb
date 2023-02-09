class Api::V1::Items::BaseController < ApplicationController
  rescue_from ActiveRecord::StatementInvalid, with: :invalid_string

  def invalid_string
    render json: ErrorSerializer.bad_data(Error.new('Price must be a number')), status: :bad_request
  end
end