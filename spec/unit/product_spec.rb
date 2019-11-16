# frozen_string_literal: true

require 'spec_helper'
require 'product'

describe Product do
  let(:watermelon) { 'Watermelons' }
  let(:quantity) { 13 }

  subject { described_class }

  describe 'initialize' do
    context 'product exist' do
      let(:product) { subject.new(watermelon, quantity) }

      it { expect(product).to be_a_kind_of(Product) }
      it { expect(product.name).to eq watermelon }
      it { expect(product.quantity).to eq quantity }
      it { expect(product.packs).to be_a_kind_of(Array) }
      it { expect(product.packs.count).to be > 0 }
      it { expect(product.packs[0]).to be_a_kind_of(Pack) }

      it 'should desc its packs by pack specification' do
        expect(product.packs[0].specification > product.packs[1].specification).to be_truthy
      end
    end

    context 'product not exist' do
      let(:error_name) { 'some name' }

      it 'should raise error' do
        expect { subject.new(error_name, 2) }
          .to raise_error OrderError, 'no such product'
      end
    end
  end

  describe 'add_quantity' do
    let(:more_quantity) { 3 }
    let(:product) { described_class.new(watermelon, quantity) }

    before { product.add_quantity(more_quantity) }

    it 'should desc its packs by pack specification' do
      expect(product.quantity).to eq quantity + more_quantity
    end
  end

  describe 'packed?' do
    let(:product) { described_class.new(watermelon, quantity) }

    context 'packed quantity equals product quantity' do
      before do
        2.times { product.packs[0].increase }
        product.packs[1].increase
      end

      it { expect(product.packed?).to be_truthy }
    end

    context 'packed quantity not equal to product quantity' do
      before do
        product.packs[0].increase
      end

      it { expect(product.packed?).to be_falsey }
    end
  end

  describe 'pack' do
    context 'correct quantity' do
      let(:loop_twice_quantity) { 16 }
      let(:product) { subject.new(watermelon, loop_twice_quantity) }

      before { product.pack }

      it 'should be packed' do
        expect(product.packed?).to be_truthy
      end

      it 'should has correct packs count' do
        expect(product.packs[0].count).to eq 2
        expect(product.packs[1].count).to eq 2
      end
    end

    context 'incorrect quantity' do
      let(:error_quantity) { 7 }
      let(:product) { subject.new(watermelon, error_quantity) }

      it 'should raise error' do
        expect { product.pack }.to raise_error OrderError,
                                               "#{watermelon} quantity error: #{error_quantity}"
      end

      it 'correct quantity after added more' do
        product.add_quantity(3)
        product.pack
        expect(product.packed?).to be_truthy
        expect(product.packs[0].count).to eq 2
      end
    end
  end

  describe 'price' do
    let(:product) { subject.new(watermelon, quantity) }

    context 'initialize' do
      it { expect(product.price).to eq 0 }
    end

    context 'after pack' do
      let(:expect_price) { product.packs[0].price * 2 + product.packs[1].price }
      before { product.pack }

      it { expect(product.price).to eq expect_price }
    end
  end

  describe 'to_s' do
    let(:product) { subject.new(watermelon, quantity) }
    let(:expect_string) do
      <<~HEREDOC
        #{quantity} #{watermelon}\t\s\s\s$#{format('%<price>.2f', price: product.price)}
        \s\s\s\s- #{product.packs[0]}
        \s\s\s\s- #{product.packs[1]}\n
      HEREDOC
    end

    context 'after pack' do
      before { product.pack }

      it { expect(product.to_s).to eq expect_string }
    end
  end
end
