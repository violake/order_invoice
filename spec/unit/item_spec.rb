# frozen_string_literal: true

require 'spec_helper'
require 'item'
require 'pack'

describe Item do
  let(:watermelon) { 'Watermelons' }
  let(:pack1) { Pack.new('name1', 8, 5.5) }
  let(:pack2) { Pack.new('name2', 5, 3.9) }
  let(:quantity) { 13 }

  describe 'initialize' do
    let(:item) { Item.new(watermelon, quantity, [pack1, pack2]) }

    it 'should desc its packs by pack specification' do
      expect(item.packs[0].specification > item.packs[1].specification).to be_truthy
    end
  end

  describe 'add_quantity' do
    let(:more_quantity) { 3 }
    let(:item) { Item.new(watermelon, quantity, [pack1, pack2]) }

    before { item.add_quantity(more_quantity) }

    it 'should desc its packs by pack specification' do
      expect(item.quantity).to eq quantity + more_quantity
    end
  end

  describe 'packed?' do
    let(:item) { Item.new(watermelon, quantity, [pack1, pack2]) }

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
      let(:loop_twice_quantity) { 16 }
      let(:pack3) { Pack.new('name3', 2, 3.9) }
      let(:item) { Item.new(watermelon, loop_twice_quantity, [pack1, pack2, pack3]) }

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
      let(:loop_once_quantity) { 13 }
      let(:pack3) { Pack.new('name3', 2, 3.9) }
      let(:item) { Item.new(watermelon, loop_once_quantity, [pack1, pack2, pack3]) }

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
      let(:loop_twice_quantity) { 20 }
      let(:pack3) { Pack.new('name3', 2, 3.9) }
      let(:item) { Item.new(watermelon, loop_twice_quantity, [pack1, pack2, pack3]) }

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
      let(:loop_triple_quantity) { 26 }
      let(:pack3) { Pack.new('name3', 3, 3.9) }
      let(:pack4) { Pack.new('name4', 9, 3.9) }
      let(:item) { Item.new(watermelon, loop_triple_quantity, [pack4, pack2, pack3]) }

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
      let(:error_quantity) { 7 }
      let(:item) { Item.new(watermelon, error_quantity, [pack1, pack2]) }

      it 'should raise error' do
        expect { item.pack }.to raise_error OrderError,
                                            "#{watermelon} quantity error: #{error_quantity}"
      end

      it 'correct quantity after added more' do
        item.add_quantity(3)
        item.pack
        expect(item.packed?).to be_truthy
        expect(item.packs[1].count).to eq 2
      end
    end
  end

  describe 'price' do
    let(:item) { Item.new(watermelon, quantity, [pack1, pack2]) }

    context 'initialize' do
      it { expect(item.price).to eq 0 }
    end

    context 'after pack' do
      before { item.pack }

      it { expect(item.price).to eq pack1.price + pack2.price }
    end
  end

  describe 'to_s' do
    let(:item) { Item.new(watermelon, quantity, [pack1, pack2]) }
    let(:expect_string) do
      <<~HEREDOC
        #{quantity} #{watermelon}\t\s\s\s$#{format('%<price>.2f', price: item.price)}
        \s\s\s\s- #{pack1}
        \s\s\s\s- #{pack2}\n
      HEREDOC
    end

    context 'after pack' do
      before { item.pack }

      it { expect(item.to_s).to eq expect_string }
    end
  end
end
