# frozen_string_literal: true

require 'spec_helper'
require 'order'
require 'order_error'

describe Order do
  let(:watermelon) { 'Watermelons' }
  let(:pineapple) { 'Pineapples' }
  let(:quantity1) { 8 }

  subject { described_class.new }

  describe 'add_item' do
    context 'add new item order' do
      before { subject.add_item("#{quantity1} #{watermelon}") }

      it 'should create new order' do
        expect(subject.items.count).to eq 1
      end

      it { expect(subject.items.first.name).to eq watermelon }
      it { expect(subject.items.first.quantity).to eq quantity1 }
    end

    context 'add existing item order' do
      before do
        2.times { subject.add_item("#{quantity1} #{watermelon}") }
      end

      it 'should add quantity to existing order' do
        expect(subject.items.count).to eq 1
      end

      it { expect(subject.items.first.quantity).to eq(quantity1 * 2) }
    end

    context 'add error fruit name' do
      it 'should raise item error' do
        expect { subject.add_item("#{quantity1} some fruit") }
          .to raise_error(OrderError, 'no such item')
      end
    end

    context 'add error quantity' do
      it 'should raise quantity type error' do
        expect { subject.add_item("3.2 #{watermelon}") }
          .to raise_error(OrderError, 'item quantity error')
      end
    end
  end
end
