# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'
require 'product'
require 'order_error'

class OrderCalculator
  attr_reader :products

  def initialize(products)
    @products = products
  end

  def calc_total_price(items)
    items.inject(BigDecimal(0)) { |sum, item| sum + item.price }
  end

  def calc_item_packs(item)
    available_packs, desc_pack_numbers = desc_sorted_packs_new(item.name)
    pack_times = calc_pack_times(item.number, desc_pack_numbers, 0)

    unless pack_times
      raise OrderError.new(OrderError::ITEM_NUMBER_ERROR,
                           "#{item.name} number error: #{item.number}")
    end

    add_times_to_packs(available_packs, pack_times)
  end

  def calc_item_price(item)
    item.packs.inject(BigDecimal(0)) do |sum, pack|
      sum + pack[:price].to_d * pack[:number].to_d
    end
  end

  private

  def add_times_to_packs(available_packs, pack_times)
    packs = []

    pack_times.each_with_index do |times, index|
      packs << available_packs[index].merge(number: times) if times.positive?
    end

    packs
  end

  def desc_sorted_packs_new(item_name)
    available_packs = products.find_by_name(item_name)[:packs]
    available_packs = available_packs.sort { |pack1, pack2| pack2[:specification] <=> pack1[:specification] }

    divisor_arr = available_packs.map { |pack| pack[:specification] }

    [available_packs, divisor_arr]
  end

  def calc_pack_times(num, divisor_arr, index)
    quotient, remainder = num.divmod divisor_arr[index]

    if remainder.zero?
      pack_times = []
      pack_times << quotient
      (divisor_arr.size - index - 1).times { pack_times << 0 }
      return pack_times
    end

    return nil if divisor_arr.size == index + 1

    quotient.downto(0).to_a.map do |next_quotient|
      next_remainder = num - next_quotient * divisor_arr[index]
      next_index = index + 1
      return_times = calc_pack_times(next_remainder, divisor_arr, next_index)
      if return_times
        return return_times.unshift(next_quotient)
      else
        next
      end
    end

    nil
  end
end
