# frozen_string_literal: true

require 'spec_helper'
require 'order'

describe Order do
  subject { described_class.new }

  context 'correct order' do
    let(:expect_invoice) do
      <<~HEREDOC
        10 Watermelons\t\s\s\s$17.98
            - 2 * 5 pack / $8.99

        14 Pineapples\t\s\s\s$54.80
            - 1 * 8 pack / $24.95
            - 3 * 2 pack / $9.95

        13 Rockmelons\t\s\s\s$25.85
            - 2 * 5 pack / $9.95
            - 1 * 3 pack / $5.95


        ----------------------------
        TOTAL:             $98.63
      HEREDOC
    end

    before do
      subject.add_item('10 Watermelons')
      subject.add_item('14 Pineapples')
      subject.add_item('13 Rockmelons')
    end

    it 'should able to generate invoice' do
      expect(subject.invoice).to eq expect_invoice
    end
  end

  context 'incorrect order' do
    context 'item name error' do
      it 'should raise error when add order' do
        expect { subject.add_item('10 Cucumber') }
          .to raise_error OrderError, 'no such item'
      end
    end

    context 'item quantity error' do
      before do
        subject.add_item('2 Watermelons')
      end

      it 'should raise error when get invoice' do
        expect { subject.invoice }
          .to raise_error OrderError, 'Watermelons quantity error: 2'
      end
    end
  end
end
