require 'spec_helper'

describe ImporterErrors do
  let(:errors) { double(:errors, full_messages: ['not enough cowbell']) }
  let(:invalid) { double(:record, valid?: false, errors: errors) }

  subject(:importer_errors) { ImporterErrors.new(invalid, 6) }

  its(:line_number) { is_expected.to eq 6 }
  its(:message) { is_expected.to eq 'Line 6: not enough cowbell' }

  describe '.messages_for' do
    let(:valid) { double(:record, valid?: true) }

    it 'collects the messages for all records by order of appearance' do
      messages = ImporterErrors.messages_for([valid, invalid])
      expect(messages).to eq ['Line 3: not enough cowbell']
    end
  end
end
