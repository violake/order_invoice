# frozen_string_literal: true

module Util
  module TypeValidation
    def integer?(quantity)
      quantity.to_s.to_i.to_s == quantity.to_s
    end
  end
end
