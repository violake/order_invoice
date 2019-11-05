# frozen_string_literal: true

require 'spec_helper'
require 'order_calculator'
require 'order'
require 'order_error'

describe OrderCalculator do
  let(:order) { Order.new }

  subject { order.calculator }

  describe 'calc_item_packs' do
    context 'correct item number' do
      context 'recursive loop once of quotient' do
        let(:expect_packs) do
          [
            { name: '9 pack', specification: 9, number: 1, price: 16.99 },
            { name: '5 pack', specification: 5, number: 1, price: 9.95 }
          ]
        end

        before do
          order.add_item('14 Rockmelons')
        end

        it 'should calculate correct number of packs to the item' do
          packs = subject.calc_item_packs(order.items[0])
          expect(packs).to eq expect_packs
        end
      end

      context 'recursive loop multiple times of quotient' do
        let(:expect_packs) do
          [
            { name: '5 pack', specification: 5, number: 2, price: 9.95 },
            { name: '3 pack', specification: 3, number: 2, price: 5.95 }
          ]
        end

        before do
          order.add_item('16 Rockmelons')
        end

        it 'should calculate correct number of packs to the item' do
          packs = subject.calc_item_packs(order.items[0])
          expect(packs).to eq expect_packs
        end
      end
    end

    context 'incorrect item number' do
      before do
        order.add_item('7 Rockmelons')
      end

      it 'should raise error' do
        expect { subject.calc_item_packs(order.items[0]) }
          .to raise_error OrderError, 'Rockmelons number error: 7'
      end
    end
  end

  describe 'calc_item_price' do
    before do
      order.add_item('14 Rockmelons')
      order.items.first.pack_item(subject)
    end

    it { expect(subject.calc_item_price(order.items[0])).to eq BigDecimal('26.94') }
  end

  describe 'calc_total_price' do
    before do
      order.add_item('14 Rockmelons')
      order.add_item('10 Watermelons')
      order.items.map { |item| item.pack_item(subject) }
    end

    it { expect(subject.calc_total_price(order.items)).to eq BigDecimal('44.92') }
  end
end
