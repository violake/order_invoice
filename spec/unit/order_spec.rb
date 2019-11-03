# frozen_string_literal: true

require 'spec_helper'
require 'order'

describe Order do
  let(:watermelon) { 'Watermelons' }
  let(:pineapple) { 'Pineapples' }
  let(:number1) { 8 }

  subject { described_class.new }

  describe 'add_item' do
    context 'add new fruit order' do
      before { subject.add_item("#{number1} #{watermelon}") }

      it 'should create new order' do
        expect(subject.items.count).to eq 1
      end

      it { expect(subject.items.first[:name]).to eq watermelon }
      it { expect(subject.items.first[:number]).to eq number1 }
    end

    context 'add existing fruit order' do
      before do
        2.times { subject.add_item("#{number1} #{watermelon}") }
      end

      it 'should add number to existing order' do
        expect(subject.items.count).to eq 1
      end

      it { expect(subject.items.first[:number]).to eq(number1 * 2) }
    end
  end
end