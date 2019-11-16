# frozen_string_literal: true

require 'product'
require 'order_error'

class Order
  attr_reader :products

  def initialize
    @products = []
  end

  def add_product(command)
    quantity, product_name = permitted_params(command)

    if products_include?(product_name)
      accumlate_product_quantity(product_name, quantity)
    else
      add_new_product(product_name, quantity)
    end
  end

  def invoice(output = $stdout)
    products.map(&:pack)

    output << formatted_invoice
  end

  private

  def formatted_invoice
    <<~HEREDOC
      #{products.inject('') { |products, product| products + product.to_s }}
      ----------------------------
      TOTAL:             $#{format('%<price>.2f', price: total_price)}
    HEREDOC
  end

  def permitted_params(command)
    quantity, product_name = command.strip.split(' ')
    raise OrderError.new(OrderError::PARAMETER_INVALID, 'product quantity error') unless integer?(quantity)

    [quantity.to_i, product_name]
  end

  def total_price
    products.inject(BigDecimal(0)) { |sum, product| sum + product.price }
  end

  def integer?(quantity)
    quantity.to_s.to_i.to_s == quantity.to_s
  end

  def add_new_product(product_name, quantity)
    products << Product.new(product_name, quantity)
  end

  def accumlate_product_quantity(product_name, quantity)
    products.find { |product| product.name == product_name }.add_quantity(quantity)
  end

  def products_include?(product_name)
    products.any? { |product| product.name == product_name }
  end
end
