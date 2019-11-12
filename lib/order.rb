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
    quantity, item_name = permitted_params(command)

    if items_include?(item_name)
      accumlate_item_quantity(item_name, quantity)
    else
      add_new_item(item_name, quantity)
    end
  end

  def invoice
    items.map(&:pack)

    formatted_invoice
  end

  private

  def formatted_invoice
    <<~HEREDOC
      #{items.inject('') { |items, item| items + item.to_s }}
      ----------------------------
      TOTAL:             $#{format('%<price>.2f', price: total_price)}
    HEREDOC
  end

  def permitted_params(command)
    quantity, item_name = command.split(' ')
    raise OrderError.new(OrderError::PARAMETER_INVALID, 'item quantity error') unless integer?(quantity)

    [quantity.to_i, item_name]
  end

  def total_price
    items.inject(BigDecimal(0)) { |sum, item| sum + item.price }
  end

  def integer?(quantity)
    quantity.to_s.to_i.to_s == quantity.to_s
  end

  def add_new_item(item_name, quantity)
    items << Product.new_item(item_name, quantity)
  end

  def accumlate_item_quantity(item_name, quantity)
    items.find { |item| item.name == item_name }.add_quantity(quantity)
  end

  def items_include?(item_name)
    items.any? { |item| item.name == item_name }
  end
end
