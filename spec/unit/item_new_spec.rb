# frozen_string_literal: true

require 'spec_helper'
require 'item_new'
require 'pack'

describe ItemNew do
  let(:watermelon) { 'Watermelons' }
  let(:pack1) { Pack.new('name1', 8, 5.5) }
  let(:pack2) { Pack.new('name2', 5, 3.9) }
  let(:number) { 13 }

  describe 'initialize' do
    let(:item) { ItemNew.new(watermelon, number, [pack1, pack2]) }

    it 'should desc its packs by pack specification' do
      expect(item.packs[0].specification > item.packs[1].specification).to be_truthy
    end
  end

  describe 'add_quantity' do
    let(:more_quantity) { 3 }
    let(:item) { ItemNew.new(watermelon, number, [pack1, pack2]) }

    before { item.add_quantity(more_quantity) }

    it 'should desc its packs by pack specification' do
      expect(item.number).to eq number + more_quantity
    end
  end

  describe 'packed?' do
    let(:item) { ItemNew.new(watermelon, number, [pack1, pack2]) }

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

  describe 'pack' do
    context 'correct quantity first round' do
      let(:loop_twice_number) { 16 }
      let(:pack3) { Pack.new('name3', 2, 3.9) }
      let(:item) { ItemNew.new(watermelon, loop_twice_number, [pack1, pack2, pack3]) }

      before { item.pack }

      it 'should be packed' do
        expect(item.packed?).to be_truthy
      end

      it 'should has correct packs count' do
        expect(item.packs[0].count).to eq 2
        expect(item.packs[1].count).to eq 0
      end
    end

    context 'correct quantity loop once' do
      let(:loop_once_number) { 13 }
      let(:pack3) { Pack.new('name3', 2, 3.9) }
      let(:item) { ItemNew.new(watermelon, loop_once_number, [pack1, pack2, pack3]) }

      before { item.pack }

      it 'should be packed' do
        expect(item.packed?).to be_truthy
      end

      it 'should has correct packs count' do
        expect(item.packs[0].count).to eq 1
        expect(item.packs[1].count).to eq 1
      end
    end

    context 'correct quantity loop twice' do
      let(:loop_twice_number) { 20 }
      let(:pack3) { Pack.new('name3', 2, 3.9) }
      let(:item) { ItemNew.new(watermelon, loop_twice_number, [pack1, pack2, pack3]) }

      before { item.pack }

      it 'should be packed' do
        expect(item.packed?).to be_truthy
      end

      it 'should has correct packs count' do
        expect(item.packs[0].count).to eq 1
        expect(item.packs[1].count).to eq 2
        expect(item.packs[2].count).to eq 1
      end
    end

    context 'correct quantity loop triple times' do
      let(:loop_triple_number) { 26 }
      let(:pack3) { Pack.new('name3', 3, 3.9) }
      let(:pack4) { Pack.new('name4', 9, 3.9) }
      let(:item) { ItemNew.new(watermelon, loop_triple_number, [pack4, pack2, pack3]) }

      before { item.pack }

      it 'should be packed' do
        expect(item.packed?).to be_truthy
      end

      it 'should has correct packs count' do
        expect(item.packs[0].count).to eq 0
        expect(item.packs[1].count).to eq 4
        expect(item.packs[2].count).to eq 2
      end
    end

    context 'incorrect quantity' do
      let(:error_number) { 7 }
      let(:item) { ItemNew.new(watermelon, error_number, [pack1, pack2]) }

      it 'should raise error' do
        expect { item.pack }.to raise_error OrderError,
                                            "#{watermelon} number error: #{error_number}"
      end

      it 'correct quantity after added more' do
        item.add_quantity(3)
        item.pack
        expect(item.packed?).to be_truthy
        expect(item.packs[1].count).to eq 2
      end
    end
  end
end
