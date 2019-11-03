# frozen_string_literal: true

require 'product'

class Invoice
  attr_reader :products, :orders

  def initialize
    @products = Product
    @orders = []
  end

  def add_order(order_str)
    number, fruit_name = order_str.split(' ')
    raise StandardError, 'no such fruit' unless valid_fruit?(fruit_name)
    raise StandardError, 'fruit number error' unless integer?(number)

    number = number.to_i

    if fruit_in_orders?(fruit_name)
      accumlate_order_number(fruit_name, number)
    else
      add_new_order(fruit_name, number)
    end
  end

  def invoice
  end

  private

  def integer?(number)
    number.to_s.to_i.to_s == number.to_s
  end

  def add_new_order(fruit_name, number)
    orders << { name: fruit_name, number: number }
  end

  def accumlate_order_number(fruit_name, number)
    orders.find { |order| order[:name] == fruit_name }[:number] += number
  end

  def fruit_in_orders?(fruit_name)
    orders.any? { |order| order[:name] == fruit_name }
  end

  def valid_fruit?(fruit_name)
    products.exist?(fruit_name)
  end
end
