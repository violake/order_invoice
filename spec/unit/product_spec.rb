# frozen_string_literal: true

require 'spec_helper'
require 'product'

describe Product do
  subject { described_class }

  describe 'all' do
    let(:products) { subject.all }

    it 'should return 3 products' do
      expect(products.count).to eq 3
    end

    it 'should get product name' do
      expect(products.first[:name]).not_to be_nil
    end

    it 'should get product packs' do
      expect(products.first[:packs]).not_to be_nil
    end

    it 'should get product pack number' do
      expect(products.first[:packs].first[:number]).to be_a_kind_of(Numeric)
    end

    it 'should get product pack price' do
      expect(products.first[:packs].first[:price]).to be_a_kind_of(Numeric)
    end
  end

  describe 'find_by_name' do
    let(:fruit_name) { 'Watermelons' }

    it 'should get product by name' do
      product = subject.find_by_name(fruit_name)
      expect(product[:name]).to eq fruit_name
    end
  end

  describe 'exist' do
    let(:fruit_name) { 'Watermelons' }
    let(:error_name) { 'some name' }

    it { expect(subject.exist(fruit_name)).to eq true }
    it { expect(subject.exist(error_name)).to eq false }
  end
end
