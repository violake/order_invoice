# frozen_string_literal: true

class Pack
  attr_reader :name, :specification, :price, :number
  def initialize(name, specification, price)
    @name = name
    @specification = specification
    @price = price
    @number = 0
  end

  def quantity
    specification * number
  end

  def add
    @number += 1
  end
end
