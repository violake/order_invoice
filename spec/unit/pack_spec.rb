# frozen_string_literal: true

require 'spec_helper'
require 'pack'

describe Pack do
  let(:name) { '8 pack' }
  let(:specification) { 8 }
  let(:price) { 8.99 }
  let(:pack) { Pack.new(name, specification, price) }

  describe 'try_max' do
    context 'initialized' do
      it { expect(pack.count).to eq 0 }
    end

    context 'quantity is divided evenly by specification' do
      before { pack.try_max(16) }

      it { expect(pack.count).to eq 2 }
    end

    context 'quantity is not divided evenly by specification' do
      before { pack.try_max(18) }

      it { expect(pack.count).to eq 2 }
    end
  end

  describe 'decrease' do
    context 'count > 0' do
      before do
        pack.try_max(16)
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

    context 'one time of specification' do
      before { pack.try_max(specification) }

      it { expect(pack.quantity).to eq 1 * specification }
    end

    context 'multiple times of specification' do
      before { pack.try_max(specification * 3) }

      it { expect(pack.quantity).to eq 3 * specification }
    end
  end

  describe 'total_price' do
    context 'initialized' do
      it { expect(pack.total_price).to eq 0 }
    end

    context 'one time of specification' do
      before { pack.try_max(specification) }

      it { expect(pack.total_price).to eq price.to_d * 1 }
    end

    context 'multiple times of specification' do
      before { pack.try_max(specification * 3) }

      it { expect(pack.total_price).to eq price.to_d * 3 }
    end
  end

  describe 'to_s' do
    context 'two times of specification' do
      before { pack.try_max(specification * 2) }

      it { expect(pack.to_s).to eq "2 * #{name} / $#{price}" }
    end
  end
end
