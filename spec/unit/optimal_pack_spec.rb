# frozen_string_literal: true

require 'spec_helper'
require 'product'
require 'optimal_packing'

describe OptimalPacking do
  let(:watermelon) { 'Watermelons' }
  let(:pineapples) { 'Pineapples' }
  let(:rockmelons) { 'Rockmelons' }

  subject { described_class }

  describe 'call' do
    context 'correct quantity first round' do
      let(:no_loop_quantity) { 10 }
      let(:product) { Product.new(watermelon, no_loop_quantity) }

      before { described_class.new(product).call }

      it 'should be packed' do
        expect(product.packed?).to be_truthy
      end

      it 'should has correct packs count' do
        expect(product.packs[0].count).to eq 2
        expect(product.packs[1].count).to eq 0
      end
    end

    context 'correct quantity loop once' do
      let(:loop_once_quantity) { 13 }
      let(:product) { Product.new(rockmelons, loop_once_quantity) }

      before { described_class.new(product).call }

      it 'should be packed' do
        expect(product.packed?).to be_truthy
      end

      it 'should has correct packs count' do
        expect(product.packs[0].count).to eq 0
        expect(product.packs[1].count).to eq 2
        expect(product.packs[2].count).to eq 1
      end
    end

    context 'correct quantity loop twice' do
      let(:loop_twice_quantity) { 12 }
      let(:product) { Product.new(watermelon, loop_twice_quantity) }

      before { described_class.new(product).call }

      it 'should be packed' do
        expect(product.packed?).to be_truthy
      end

      it 'should has correct packs count' do
        expect(product.packs[0].count).to eq 0
        expect(product.packs[1].count).to eq 4
      end
    end

    context 'correct quantity recursive three times' do
      let(:loop_triple_quantity) { 6 }
      let(:product) { Product.new(pineapples, loop_triple_quantity) }

      before { described_class.new(product).call }

      it 'should be packed' do
        expect(product.packed?).to be_truthy
      end

      it 'should has correct packs count' do
        expect(product.packs[0].count).to eq 0
        expect(product.packs[1].count).to eq 0
        expect(product.packs[2].count).to eq 3
      end
    end

    context 'incorrect quantity' do
      let(:error_quantity) { 7 }
      let(:product) { Product.new(watermelon, error_quantity) }

      before { described_class.new(product).call }

      it 'should end with 0 pack count' do
        expect(product.packs[0].count).to eq 0
        expect(product.packs[1].count).to eq 0
      end
    end

    context 'item already packed' do
      let(:packed_quantity) { 10 }
      let(:product) { Product.new(watermelon, packed_quantity) }

      before { described_class.new(product).call }

      it 'should not recalculate' do
        expect_any_instance_of(described_class)
          .not_to receive(:calc_optimal_pack_count)
      end
    end
  end
end
