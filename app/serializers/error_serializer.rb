class ErrorSerializer
  def self.unprocessable(errors)
    {
      "message": "There was an error processing your request",
      "errors": errors.full_messages
    }
  end

  def self.bad_data(error)
    {
      "message": "There was an error processing your request",
      "errors": error.message
    }
  end

  def self.no_data
    {
      data: {}
    }
  end
end