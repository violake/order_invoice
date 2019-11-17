# frozen_string_literal: true

require 'spec_helper'
require 'util/type_validation'

describe Util::TypeValidation do
  subject { class TypeClass include Util::TypeValidation; end.new }

  describe 'integer?' do
    context 'integer' do
      let(:int_a) { 3 }
      it { expect(subject.integer?(int_a)).to be_truthy }
    end

    context 'string value is int' do
      let(:string_a) { '5' }
      it { expect(subject.integer?(string_a)).to be_truthy }
    end

    context 'float' do
      let(:float_a) { 3.45 }
      it { expect(subject.integer?(float_a)).to be_falsey }
    end

    context 'string' do
      let(:string_a) { 'c' }
      it { expect(subject.integer?(string_a)).to be_falsey }
    end

    context 'nil' do
      it { expect(subject.integer?(nil)).to be_falsey }
    end
  end
end
