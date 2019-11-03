# frozen_string_literal: true

require 'product'

class Order
  attr_reader :products, :items

  def initialize
    @products = Product
    @items = []
  end

  def add_item(item_str)
    number, fruit_name = item_str.split(' ')
    raise ArgumentError, 'no such fruit' unless valid_fruit?(fruit_name)
    raise ArgumentError, 'fruit number error' unless integer?(number)

    number = number.to_i

    if fruit_in_items?(fruit_name)
      accumlate_item_number(fruit_name, number)
    else
      add_new_item(fruit_name, number)
    end
  end

  def invoice
  end

  private

  def integer?(number)
    number.to_s.to_i.to_s == number.to_s
  end

  def add_new_item(fruit_name, number)
    items << { name: fruit_name, number: number }
  end

  def accumlate_item_number(fruit_name, number)
    items.find { |item| item[:name] == fruit_name }[:number] += number
  end

  def fruit_in_items?(fruit_name)
    items.any? { |order| order[:name] == fruit_name }
  end

  def valid_fruit?(fruit_name)
    products.exist?(fruit_name)
  end
end
