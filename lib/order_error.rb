# frozen_string_literal: true

class OrderError < StandardError
  attr_reader :error_type

  PARAMETER_INVALID = 'parameter_invalid'
  ITEM_QUANTITY_ERROR = 'item_quantity_error'

  def initialize(error_type, error_message)
    super(error_message)
    @error_type = error_type
  end
end
