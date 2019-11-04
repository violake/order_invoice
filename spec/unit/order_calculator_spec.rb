# frozen_string_literal: true

require 'spec_helper'
require 'order_calculator'
require 'order'
require 'order_error'

describe OrderCalculator do
  let(:order) { Order.new }

  subject { OrderCalculator }

  describe 'calculate_item_packs' do
    context 'correct item number' do
      let(:expect_items) do
        {
          name: 'Rockmelons',
          number: 14,
          packs: [
            { name: '9 pack', specification: 9, number: 1, price: 16.99 },
            { name: '5 pack', specification: 5, number: 1, price: 9.95 }
          ]
        }
      end

      before do
        order.add_item('14 Rockmelons')
      end

      it 'should calculate correct number of packs to the item' do
        calculator = subject.new(order)
        expect(calculator.send('calculate_item_packs', order.items[0]))
          .to eq expect_items
      end
    end

    context 'incorrect item number' do
      before do
        order.add_item('7 Rockmelons')
      end

      it 'should raise error' do
        calculator = subject.new(order)
        expect { calculator.send('calculate_item_packs', order.items[0]) }
          .to raise_error OrderError, 'Rockmelons number error: 7'
      end
    end
  end

  describe 'calculate_items_price' do
    context 'correct items' do
      let(:expect_calculated_order) do
        {
          items: [
            {
              name: 'Watermelons',
              number: 10,
              price: BigDecimal('17.98'),
              packs: [
                { name: '5 pack', number: 2, price: 8.99, specification: 5 }
              ]
            },
            {
              name: 'Pineapples',
              number: 14,
              price: BigDecimal('54.8'),
              packs: [
                { name: '8 pack', number: 1, price: 24.95, specification: 8 },
                { name: '2 pack', number: 3, price: 9.95, specification: 2 }
              ]
            }
          ],
          total_price: BigDecimal('72.78')
        }
      end

      before do
        order.add_item('10 Watermelons')
        order.add_item('14 Pineapples')
      end

      it 'should get price for each items and total price' do
        calculator = subject.new(order)
        expect(calculator.items_with_price)
          .to eq expect_calculated_order
      end
    end

    context 'incorrect item number' do
      before do
        order.add_item('4 Watermelons')
      end

      it 'should raise error' do
        calculator = subject.new(order)
        expect { calculator.items_with_price }
          .to raise_error OrderError, 'Watermelons number error: 4'
      end
    end
  end
end
