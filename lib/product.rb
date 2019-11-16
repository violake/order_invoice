# frozen_string_literal: true

require 'order_error'
require 'products'
require 'pack'
require 'optimal_packer'

class Product
  attr_reader :name, :quantity, :packs

  def initialize(name, quantity)
    product_specification = Products.find_by_name(name)
    unless product_specification
      raise OrderError.new(OrderError::PARAMETER_INVALID, 'no such product')
    end

    @name = name
    @quantity = quantity
    @packs = initialize_desc_packs(product_specification[:packs])
  end

  def packed?
    quantity == packed_quantity
  end

  def add_quantity(more_quantity)
    @quantity += more_quantity
  end

  def pack(packer = OptimalPacker)
    packer.new(self).call

    unless packed?
      raise OrderError.new(OrderError::ITEM_QUANTITY_ERROR,
                           "#{name} quantity error: #{quantity}")
    end
  end

  def price
    packs.inject(BigDecimal(0)) { |sum, pack| sum + pack.total_price }
  end

  def to_s
    <<~HERE
      #{quantity} #{name}\t\s\s\s$#{format('%<price>.2f', price: price)}
      #{packs.select { |pack| pack.count.positive? }.inject('') { |packs, pack| packs + "\s\s\s\s- #{pack}\n" }}
    HERE
  end

  private

  def initialize_desc_packs(packs)
    packs.map { |pack| Pack.new(pack[:name], pack[:specification], pack[:price]) }
         .sort { |pack1, pack2| pack2.specification <=> pack1.specification }
  end

  def packed_quantity
    packs.inject(0) { |sum, pack| sum + pack.quantity }
  end

  def desc_packs_by_specification(packs)
    packs.sort { |pack1, pack2| pack2.specification <=> pack1.specification }
  end
end
