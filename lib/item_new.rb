# frozen_string_literal: true

class ItemNew
  attr_reader :name, :number, :packs, :price

  def initialize(name, number, packs)
    @name = name
    @number = number
    @packs = desc_packs_by_specification(packs)
  end

  def packed?
    number == packs.inject(0) { |sum, pack| sum + pack.quantity }
  end

  def pack
  end

  private

  def desc_packs_by_specification(packs)
    packs.sort { |pack1, pack2| pack2.specification <=> pack1.specification }
  end
end
