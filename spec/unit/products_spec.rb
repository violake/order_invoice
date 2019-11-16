# frozen_string_literal: true

require 'spec_helper'
require 'products'

describe Products do
  subject { described_class }

  describe 'find_by_name' do
    context 'product name exist' do
      let(:watermelons) { 'Watermelons' }
      let(:product) { Products.find_by_name(watermelons) }

      it { expect(product[:name]).to eq watermelons }
      it { expect(product[:packs].count).to eq 2 }
    end

    context 'product name not exist' do
      let(:strawberry) { 'Strawberry' }
      let(:product) { Products.find_by_name(strawberry) }

      it { expect(product).to be_nil }
    end
  end
end
