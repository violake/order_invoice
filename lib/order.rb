# frozen_string_literal: true

require 'product'
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

  def invoice; end

  private

  def permitted_params(command)
    number, item_name = command.split(' ')
    unless valid_item?(item_name)
      raise OrderError.new(OrderError::PARAMETER_INVALID, 'no such item')
    end

    unless integer?(number)
      raise OrderError.new(OrderError::PARAMETER_INVALID, 'item number error')
    end

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
