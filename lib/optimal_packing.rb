# frozen_string_literal: true

class OptimalPacking
  attr_reader :product

  def initialize(product)
    @product = product
  end

  def call
    calc_optimal_pack_count(product.quantity, product.packs) unless product.packed?
  end

  private

  def calc_optimal_pack_count(quantity, packs)
    return if packs.count.zero? || product.packed?

    pack, *rest_packs = packs
    pack.try_max(quantity)

    pack.count.downto(0) do
      rest_quantity = quantity - pack.quantity
      calc_optimal_pack_count(rest_quantity, rest_packs)
      return if product.packed?

      pack.decrease
    end
  end
end
