# frozen_string_literal: true

require 'spec_helper'
require 'item'
require 'optimal_packing'

describe OptimalPacking do
  let(:watermelon) { 'Watermelons' }
  let(:pack1) { Pack.new('name1', 8, 5.5) }
  let(:pack2) { Pack.new('name2', 5, 3.9) }
  let(:quantity) { 13 }

  subject { described_class }

  describe 'call' do
    context 'correct quantity first round' do
      let(:no_loop_quantity) { 16 }
      let(:pack3) { Pack.new('name3', 2, 3.9) }
      let(:item) { Item.new(watermelon, no_loop_quantity, [pack1, pack2, pack3]) }

      before { described_class.new(item).call }

      it 'should be packed' do
        expect(item.packed?).to be_truthy
      end

      it 'should has correct packs count' do
        expect(item.packs[0].count).to eq 2
        expect(item.packs[1].count).to eq 0
      end
    end

    context 'correct quantity loop once' do
      let(:loop_once_quantity) { 13 }
      let(:pack3) { Pack.new('name3', 2, 3.9) }
      let(:item) { Item.new(watermelon, loop_once_quantity, [pack1, pack2, pack3]) }

      before { described_class.new(item).call }

      it 'should be packed' do
        expect(item.packed?).to be_truthy
      end

      it 'should has correct packs count' do
        expect(item.packs[0].count).to eq 1
        expect(item.packs[1].count).to eq 1
      end
    end

    context 'correct quantity loop twice' do
      let(:loop_twice_quantity) { 12 }
      let(:pack3) { Pack.new('name3', 3, 3.9) }
      let(:item) { Item.new(watermelon, loop_twice_quantity, [pack2, pack3]) }

      before { described_class.new(item).call }

      it 'should be packed' do
        expect(item.packed?).to be_truthy
      end

      it 'should has correct packs count' do
        expect(item.packs[0].count).to eq 0
        expect(item.packs[1].count).to eq 4
      end
    end

    context 'correct quantity loop three times' do
      let(:loop_triple_quantity) { 25 }
      let(:item) { Item.new(watermelon, loop_triple_quantity, [pack1, pack2]) }

      before { described_class.new(item).call }

      it 'should be packed' do
        expect(item.packed?).to be_truthy
      end

      it 'should has correct packs count' do
        expect(item.packs[0].count).to eq 0
        expect(item.packs[1].count).to eq 5
      end
    end

    context 'correct quantity recursive three times' do
      let(:loop_triple_quantity) { 6 }
      let(:pack3) { Pack.new('name3', 2, 3.9) }
      let(:item) { Item.new(watermelon, loop_triple_quantity, [pack1, pack2, pack3]) }

      before { described_class.new(item).call }

      it 'should be packed' do
        expect(item.packed?).to be_truthy
      end

      it 'should has correct packs count' do
        expect(item.packs[0].count).to eq 0
        expect(item.packs[1].count).to eq 0
        expect(item.packs[2].count).to eq 3
      end
    end

    context 'incorrect quantity' do
      let(:error_quantity) { 7 }
      let(:item) { Item.new(watermelon, error_quantity, [pack1, pack2]) }

      before { described_class.new(item).call }

      it 'should end with 0 pack count' do
        expect(item.packs[0].count).to eq 0
        expect(item.packs[1].count).to eq 0
      end
    end

    context 'item already packed' do
      let(:packed_quantity) { 10 }
      let(:item) { Item.new(watermelon, packed_quantity, [pack1, pack2]) }

      before { described_class.new(item).call }

      it 'should not recalculate' do
        expect_any_instance_of(described_class)
          .not_to receive(:calc_optimal_pack_count)
      end
    end
  end
end
