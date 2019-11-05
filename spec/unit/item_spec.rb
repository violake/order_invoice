# frozen_string_literal: true

require 'spec_helper'
require 'Item'
require 'order'
require 'order_calculator'

describe Item do
  let(:watermelon) { 'Watermelons' }
  let(:pineapple) { 'Pineapples' }
  let(:number) { 8 }

  subject { described_class }

  describe 'initialize' do
    let(:item) { subject.new(watermelon, number) }

    it { expect(item.name).to eq watermelon }
    it { expect(item.number).to eq number }
    it { expect(item.packs).to eq [] }
  end

  describe 'add_number' do
    let(:item) { subject.new(watermelon, number) }

    before { item.add_number(number) }

    it { expect(item.number).to eq number * 2 }
  end

  describe 'calculate_packs' do
    let(:item) { subject.new(watermelon, number) }
    let(:order) { Order.new }
    let(:expect_packs) do
      [
        { name: '5 pack', specification: 5, number: 1, price: 8.99 },
        { name: '3 pack', specification: 3, number: 1, price: 6.99 }
      ]
    end

    before { item.pack_item(order.calculator) }

    it { expect(item.packs).to eq expect_packs }
    it 'should calculated item price' do
      expect(item.price).to eq(BigDecimal('15.98'))
    end
  end
end
