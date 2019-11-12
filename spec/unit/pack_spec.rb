# frozen_string_literal: true

require 'spec_helper'
require 'pack'

describe Pack do
  let(:name) { '8 pack' }
  let(:specification) { 8 }
  let(:price) { 8.99 }
  let(:pack) { Pack.new(name, specification, price) }

  describe 'increase' do
    context 'initialized' do
      it { expect(pack.count).to eq 0 }
    end

    context 'add once' do
      before { pack.increase }

      it { expect(pack.count).to eq 1 }
    end

    context 'increase twice' do
      before { 2.times { pack.increase } }

      it { expect(pack.count).to eq 2 }
    end
  end

  describe 'decrease' do
    context 'count > 0' do
      before do
        2.times { pack.increase }
        pack.decrease
      end

      it { expect(pack.count).to eq 1 }
    end

    context 'count == 0' do
      before { pack.decrease }
      it { expect(pack.count).to eq 0 }
    end
  end

  describe 'quantity' do
    context 'initialized' do
      it { expect(pack.quantity).to eq 0 }
    end

    context 'increase once' do
      before { pack.increase }

      it { expect(pack.quantity).to eq 1 * specification }
    end

    context 'increase triple time' do
      before { 3.times { pack.increase } }

      it { expect(pack.quantity).to eq 3 * specification }
    end
  end

  describe 'total_price' do
    context 'initialized' do
      it { expect(pack.total_price).to eq 0 }
    end

    context 'increase once' do
      before { pack.increase }

      it { expect(pack.total_price).to eq price.to_d * 1 }
    end

    context 'increase triple time' do
      before { 3.times { pack.increase } }

      it { expect(pack.total_price).to eq price.to_d * 3 }
    end
  end

  describe 'to_s' do
    context 'increase once' do
      before { 2.times { pack.increase } }

      it { expect(pack.to_s).to eq "2 * #{name} / $#{price}" }
    end
  end
end
