# frozen_string_literal: true

require 'spec_helper'
require 'order'

describe Order do
  subject { described_class.new }

  context 'correct order' do
    let(:expect_invoice) do
      {
        items:
          [
            {
              name: 'Watermelons',
              number: 10,
              price: '$17.98',
              packs: [
                { name: '5 pack', number: 2, price: '$8.99' }
              ]
            },
            {
              name: 'Pineapples',
              number: 14,
              price: '$54.80',
              packs: [
                { name: '8 pack', number: 1, price: '$24.95' },
                { name: '2 pack', number: 3, price: '$9.95' }
              ]
            },
            {
              name: 'Rockmelons',
              number: 13,
              price: '$25.85',
              packs: [
                { name: '5 pack', number: 2, price: '$9.95' },
                { name: '3 pack', number: 1, price: '$5.95' }
              ]
            }
          ],
        total_price: '$98.63'
      }
    end

    before do
      subject.add_item('10 Watermelons')
      subject.add_item('14 Pineapples')
      subject.add_item('13 Rockmelons')
    end

    it 'should able to generate invoice' do
      expect(subject.invoice).to eq expect_invoice
    end
  end

  context 'incorrect order' do
    context 'item name error' do
      it 'should raise error when add order' do
        expect { subject.add_item('10 Cucumber') }
          .to raise_error OrderError, 'no such item'
      end
    end

    context 'item number error' do
      before do
        subject.add_item('2 Watermelons')
      end

      it 'should raise error when get invoice' do
        expect { subject.invoice }
          .to raise_error OrderError, 'Watermelons number error: 2'
      end
    end
  end
end
