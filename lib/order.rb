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

    product = add_or_update_product(product_name, quantity)

    product.pack
  end

  def invoice(output = $stdout)
    output << formatted_invoice
  end

  private

  def permitted_params(command)
    quantity, product_name = command.strip.split(' ')
    unless integer?(quantity)
      raise OrderError.new(OrderError::PARAMETER_INVALID, 'product quantity error')
    end

    [quantity.to_i, product_name]
  end

  def integer?(quantity)
    quantity.to_s.to_i.to_s == quantity.to_s
  end

  def add_or_update_product(product_name, quantity)
    product = find_product(product_name)

    if product
      product.add_quantity(quantity)
    else
      product = add_new_product(product_name, quantity)
    end

    product
  end

  def find_product(product_name)
    products.find { |product| product.name == product_name }
  end

  def add_new_product(product_name, quantity)
    products << product = Product.new(product_name, quantity)
    product
  end

  def formatted_invoice
    <<~HEREDOC
      #{products.inject('') { |products, product| products + product.to_s }}
      ----------------------------
      TOTAL:             $#{format('%<price>.2f', price: total_price)}
    HEREDOC
  end

  def total_price
    products.inject(BigDecimal(0)) { |sum, product| sum + product.price }
  end
end
