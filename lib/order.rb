# frozen_string_literal: true

require 'product'

class Order
  attr_reader :products, :items

  def initialize
    @products = Product
    @items = []
  end

  def add_item(item_str)
    number, item_name = item_str.split(' ')
    raise ArgumentError, 'no such item' unless valid_item?(item_name)
    raise ArgumentError, 'item number error' unless integer?(number)

    number = number.to_i

    if items_include?(item_name)
      accumlate_item_number(item_name, number)
    else
      add_new_item(item_name, number)
    end
  end

  def invoice
  end

  private

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
