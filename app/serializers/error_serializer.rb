class ErrorSerializer
  def self.serialize(errors)
    {
      "message": "There was an error processing your request",
      "errors": errors.full_messages
    }
  end
end