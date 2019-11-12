# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

class ItemNew
  attr_reader :name, :number, :packs

  def initialize(name, number, packs)
    @name = name
    @number = number
    @packs = desc_packs_by_specification(packs)
  end

  def packed?
    number == packed_quantity
  end

  def add_quantity(more_quantity)
    @number += more_quantity
  end

  def pack
    calculate_packs_count(number, packs)

    unless packed?
      raise OrderError.new(OrderError::ITEM_NUMBER_ERROR,
                           "#{name} number error: #{number}")
    end
  end

  def price
    packs.inject(BigDecimal(0)) { |sum, pack| sum + pack.total_price }
  end

  def to_s
    "#{number} #{name} #{price}"
  end

  private

  def calculate_packs_count(quantity, packs)
    return if packs.count.zero? || packed?

    pack, *rest_packs = packs
    pack.try_max(quantity)

    pack.count.downto(0) do
      rest_quantity = quantity - packed_quantity
      calculate_packs_count(rest_quantity, rest_packs)
      return if packed?

      pack.decrease
    end
  end

  def packed_quantity
    packs.inject(0) { |sum, pack| sum + pack.quantity }
  end

  def desc_packs_by_specification(packs)
    packs.sort { |pack1, pack2| pack2.specification <=> pack1.specification }
  end
end
