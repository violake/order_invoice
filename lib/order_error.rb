# frozen_string_literal: true

class OrderError < StandardError
  attr_reader :error_type

  PARAMETER_INVALID = 'parameter_invalid'
  ITEM_NUMBER_ERROR = 'item_number_error'

  def initialize(error_type, error_message)
    super(error_message)
    @error_type = error_type
  end
end
