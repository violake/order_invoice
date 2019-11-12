# frozen_string_literal: true

require 'spec_helper'
require 'pack'

describe Pack do
  let(:watermelon) { 'Watermelons' }
  let(:specification) { 8 }
  let(:price) { 8.99 }
  let(:pack) { Pack.new(watermelon, specification, price) }

  describe 'add' do
    context 'initialized' do
      it { expect(pack.number).to eq 0 }
    end

    context 'add once' do
      before { pack.add }

      it { expect(pack.number).to eq 1 }
    end

    context 'add twice' do
      before { 2.times { pack.add } }

      it { expect(pack.number).to eq 2 }
    end
  end

  describe 'quantity' do
    context 'initialized' do
      it { expect(pack.quantity).to eq 0 }
    end

    context 'add once' do
      before { pack.add }

      it { expect(pack.quantity).to eq 1 * specification }
    end

    context 'add triple time' do
      before { 3.times { pack.add } }

      it { expect(pack.quantity).to eq 3 * specification }
    end
  end
end
