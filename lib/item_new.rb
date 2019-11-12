# frozen_string_literal: true

class ItemNew
  attr_reader :name, :number, :packs, :price

  def initialize(name, number, packs)
    @name = name
    @number = number
    @packs = packs
  end

  def packed?
    number == packs.inject(0) { |sum, pack| sum + pack.quantity }
  end
end
