# frozen_string_literal: true

require 'product'
require 'item'
require 'order_calculator'
require 'order_error'

class Order
  attr_reader :products, :items, :calculator, :total_price

  def initialize
    @products = Product
    @calculator = OrderCalculator.new(products)
    @items = []
    @total_price = nil
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
    items.map { |item| item.pack_item(calculator) }

    @total_price = calculator.calc_total_price(items)

    invoice_of_formatted_price
  end

  private

  def invoice_of_formatted_price
    formatted_items = items.map do |item|
      {
        name: item.name,
        number: item.number,
        packs: item.packs.map do |pack|
          new_pack = pack.reject { |k| k == :specification }
          new_pack[:price] = price_format(new_pack[:price])
          new_pack
        end,
        price: price_format(item.price)
      }
    end

    { items: formatted_items, total_price: price_format(total_price) }
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
    items << Item.new(item_name, number)
  end

  def accumlate_item_number(item_name, number)
    items.find { |item| item.name == item_name }.add_number(number)
  end

  def items_include?(item_name)
    items.any? { |item| item.name == item_name }
  end

  def valid_item?(item_name)
    products.exist?(item_name)
  end
end
