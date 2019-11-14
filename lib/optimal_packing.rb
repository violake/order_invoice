# frozen_string_literal: true

class OptimalPacking
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def call
    calc_optimal_pack_count(item.quantity, item.packs) unless item.packed?
  end

  private

  def calc_optimal_pack_count(quantity, packs)
    return if packs.count.zero? || item.packed?

    pack, *rest_packs = packs
    pack.try_max(quantity)

    pack.count.downto(0) do
      rest_quantity = quantity - pack.quantity
      calc_optimal_pack_count(rest_quantity, rest_packs)
      return if item.packed?

      pack.decrease
    end
  end
end
