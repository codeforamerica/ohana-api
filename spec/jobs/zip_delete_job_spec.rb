require 'rails_helper'

describe ZipDeleteJob, job: true do
  describe '#perform' do
    let(:file) { 'archive.zip' }

    it 'deletes the file' do
      expect(File).to receive(:delete).with(file)

      ZipDeleteJob.new.perform(file)
    end
  end
end
