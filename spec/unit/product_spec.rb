# frozen_string_literal: true

require 'spec_helper'
require 'product'

describe Product do
  subject { described_class }

  describe 'new_item' do
    context 'item exist' do
      let(:fruit_name) { 'Watermelons' }
      let(:number) { 7 }
      let(:item) { subject.new_item(fruit_name, number) }

      it { expect(item).to be_a_kind_of(ItemNew) }
      it { expect(item.name).to eq fruit_name }
      it { expect(item.number).to eq number }
      it { expect(item.packs).to be_a_kind_of(Array) }
      it { expect(item.packs.count).to be > 0 }
      it { expect(item.packs[0]).to be_a_kind_of(Pack) }
    end

    context 'item not exist' do
      let(:error_name) { 'some name' }

      it 'should raise error' do
        expect { subject.new_item(error_name, 2) }
          .to raise_error OrderError, 'no such item'
      end
    end
  end
end
