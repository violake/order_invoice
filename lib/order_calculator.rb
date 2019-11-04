# frozen_string_literal: true

require 'bigdecimal'
require 'product'
require 'order_error'

class OrderCalculator
  attr_reader :items, :products

  def initialize(order)
    @items = order.items
    @products = order.products
  end

  def items_with_price
    calculated_packed_items = calculate_packed_items

    total_price = calculated_packed_items.inject(BigDecimal(0)) do |sum, item|
      sum + BigDecimal(item[:price].to_s)
    end

    { items: calculated_packed_items, total_price: total_price }
  end

  private

  def calculate_packed_items
    items.map do |item|
      calculate_item_total_price(calculate_item_packs(item))
    end
  end

  def calculate_item_total_price(item)
    item_total_price = item[:packs].inject(BigDecimal(0)) do |sum, pack|
      sum + BigDecimal(pack[:price].to_s) * BigDecimal(pack[:number])
    end

    item.merge(price: item_total_price)
  end

  def calculate_item_packs(item)
    available_packs, seed_arr = desc_sorted_packs(item)
    pack_times = calc_pack_times(item[:number], seed_arr, 0)

    unless pack_times
      raise OrderError.new(OrderError::ITEM_NUMBER_ERROR,
                           "#{item[:name]} number error: #{item[:number]}")
    end

    add_packs_to_item(available_packs, pack_times, item)
  end

  def add_packs_to_item(available_packs, pack_times, item)
    item[:packs] = []

    pack_times.each_with_index do |times, index|
      item[:packs] << available_packs[index].merge(number: times) if times.positive?
    end

    item
  end

  def desc_sorted_packs(item)
    available_packs = products.find_by_name(item[:name])[:packs]
    available_packs = available_packs.sort { |pack1, pack2| pack2[:specification] <=> pack1[:specification] }

    seed_arr = available_packs.map { |pack| pack[:specification] }

    [available_packs, seed_arr]
  end

  def calc_pack_times(num, seed_arr, index)
    quotient, remainder = num.divmod seed_arr[index]

    if remainder.zero?
      answer = []
      answer << quotient
      (seed_arr.size - index - 1).times { answer << 0 }
      return answer
    else
      return nil if seed_arr.size == index + 1

      quotient.downto(0).to_a.map do |next_quotient|
        next_remainder = num - next_quotient * seed_arr[index]
        next_index = index + 1
        rest_answer = calc_pack_times(next_remainder, seed_arr, next_index)
        if rest_answer
          return rest_answer.unshift(next_quotient)
        else
          next
        end
      end
    end

    nil
  end
end
