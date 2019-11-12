# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

class Pack
  attr_reader :name, :specification, :price, :count

  def initialize(name, specification, price)
    @name = name
    @specification = specification
    @price = price
    @count = 0
  end

  def total_price
    price.to_d * count
  end

  def quantity
    specification * count
  end

  def try_max(quantity)
    @count = quantity / specification
  end

  def increase
    @count += 1
  end

  def decrease
    @count -= 1 if count.positive?
  end

  def to_s
    "#{count} * #{name} / #{price}"
  end
end
