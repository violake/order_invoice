# frozen_string_literal: true

require 'spec_helper'
require 'order'
require 'order_error'

describe Order do
  let(:watermelon) { 'Watermelons' }
  let(:pineapple) { 'Pineapples' }
  let(:quantity1) { 8 }

  subject { described_class.new }

  describe 'add_product' do
    context 'add new product order' do
      before { subject.add_product("#{quantity1} #{watermelon}") }

      it 'should create new order' do
        expect(subject.products.count).to eq 1
      end

      it { expect(subject.products.first.name).to eq watermelon }
      it { expect(subject.products.first.quantity).to eq quantity1 }
    end

    context 'add existing product order' do
      before do
        2.times { subject.add_product("#{quantity1} #{watermelon}") }
      end

      it 'should add quantity to existing order' do
        expect(subject.products.count).to eq 1
      end

      it { expect(subject.products.first.quantity).to eq(quantity1 * 2) }
    end

    context 'add error fruit name' do
      it 'should raise product error' do
        expect { subject.add_product("#{quantity1} some fruit") }
          .to raise_error(OrderError, 'no such product')
      end
    end

    context 'add error quantity' do
      it 'should raise quantity type error' do
        expect { subject.add_product("3.2 #{watermelon}") }
          .to raise_error(OrderError, 'product quantity error')
      end
    end
  end
end
