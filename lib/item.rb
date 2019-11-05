# frozen_string_literal: true

class Item
  attr_reader :name, :number, :packs, :price

  def initialize(name, number)
    @name = name
    @number = number
    @packs = []
  end

  def add_number(number)
    @number += number
  end

  def pack_item(calculator)
    @packs = calculator.calc_item_packs(self)
    calc_item_price(calculator)
  end

  private

  def calc_item_price(calculator)
    @price = calculator.calc_item_price(self)
  end
end
