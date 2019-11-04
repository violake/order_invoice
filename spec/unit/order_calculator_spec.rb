# frozen_string_literal: true

require 'spec_helper'
require 'order_calculator'
require 'order'
require 'order_error'

describe OrderCalculator do
  let(:order) { Order.new }

  subject { OrderCalculator }

  describe 'calculate_items_packs' do
    context 'correct item number when one item' do
      let(:expect_items) do
        [{
          name: 'Rockmelons',
          number: 14,
          packs: [
            { name: '9 pack', specification: 9, number: 1, price: 16.99 },
            { name: '5 pack', specification: 5, number: 1, price: 9.95 }
          ]
        }]
      end

      before do
        order.add_item('14 Rockmelons')
      end

      it 'should calculate correct number of packs to the item' do
        calculator = subject.new(order)
        expect(calculator.calculate_item_packs)
          .to eq expect_items
      end
    end

    context 'correct item numbers when two items' do
      let(:expect_items) do
        [
          {
            name: 'Watermelons',
            number: 8,
            packs: [
              { name: '5 pack', specification: 5, number: 1, price: 8.99 },
              { name: '3 pack', specification: 3, number: 1, price: 6.99 }
            ]
          },
          {
            name: 'Rockmelons',
            number: 13,
            packs: [
              { name: '5 pack', specification: 5, number: 2, price: 9.95 },
              { name: '3 pack', specification: 3, number: 1, price: 5.95 }
            ]
          }
        ]
      end
      before do
        order.add_item('8 Watermelons')
        order.add_item('13 Rockmelons')
      end

      it 'should calculate correct number of packs to the item' do
        calculator = subject.new(order)
        expect(calculator.calculate_item_packs)
          .to eq expect_items
      end
    end

    context 'incorrect item number when one item' do
      before do
        order.add_item('7 Rockmelons')
      end

      it 'should raise error' do
        calculator = subject.new(order)
        expect { calculator.calculate_item_packs }
          .to raise_error OrderError, 'Rockmelons number error: 7'
      end
    end

    context 'one incorrect item number when two items' do
      before do
        order.add_item('10 Rockmelons')
        order.add_item('4 Watermelons')
      end

      it 'should raise error' do
        calculator = subject.new(order)
        expect { calculator.calculate_item_packs }
          .to raise_error OrderError, 'Watermelons number error: 4'
      end
    end
  end
end
