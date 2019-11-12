# frozen_string_literal: true

require 'spec_helper'
require 'item_new'
require 'pack'

describe ItemNew do
  let(:watermelon) { 'Watermelons' }
  let(:pack1) { Pack.new('name1', 5, 5.5) }
  let(:pack2) { Pack.new('name2', 3, 3.9) }
  let(:number) { 8 }
  let(:item) { ItemNew.new(watermelon, number, [pack1, pack2]) }

  describe 'initialize' do
    it 'should desc its packs by pack specification' do
      expect(item.packs[0].specification > item.packs[1].specification).to be_truthy
    end
  end

  describe 'packed?' do
    context 'packed quantity equals item quantity' do
      before do
        item.packs.map(&:increase)
      end

      it { expect(item.packed?).to be_truthy }
    end

    context 'packed quantity not equal to item quantity' do
      before do
        item.packs[0].increase
      end

      it { expect(item.packed?).to be_falsey }
    end
  end
end
