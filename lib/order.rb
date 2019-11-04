# frozen_string_literal: true

require 'product'
require 'order_calculator'
require 'order_error'

class Order
  attr_reader :products, :items

  def initialize
    @products = Product
    @items = []
  end

  def add_item(command)
    number, item_name = permitted_params(command)

    if items_include?(item_name)
      accumlate_item_number(item_name, number)
    else
      add_new_item(item_name, number)
    end
  end

  def invoice
    order_calculator = OrderCalculator.new(self)
    items_with_price = order_calculator.items_with_price

    invoice = decorated_invoice(items_with_price)
    invoice
  end

  private

  def decorated_invoice(items_with_price)
    items_with_price[:items] = items_with_price[:items].map do |item|
      item[:packs] = item[:packs].map do |pack|
        new_pack = pack.reject { |k| k == :specification }
        new_pack[:price] = price_format(new_pack[:price])
        new_pack
      end

      item[:price] = price_format(item[:price])
      item
    end

    items_with_price[:total_price] = price_format(items_with_price[:total_price])
    items_with_price
  end

  def price_format(num)
    '$' + format('%<number>.2f', number: num)
  end

  def permitted_params(command)
    number, item_name = command.split(' ')
    raise OrderError.new(OrderError::PARAMETER_INVALID, 'no such item') unless valid_item?(item_name)
    raise OrderError.new(OrderError::PARAMETER_INVALID, 'item number error') unless integer?(number)

    [number.to_i, item_name]
  end

  def integer?(number)
    number.to_s.to_i.to_s == number.to_s
  end

  def add_new_item(item_name, number)
    items << { name: item_name, number: number }
  end

  def accumlate_item_number(item_name, number)
    items.find { |item| item[:name] == item_name }[:number] += number
  end

  def items_include?(item_name)
    items.any? { |order| order[:name] == item_name }
  end

  def valid_item?(item_name)
    products.exist?(item_name)
  end
end
