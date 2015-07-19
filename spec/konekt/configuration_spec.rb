require 'konekt/configuration'

module Konekt
  RSpec.describe Configuration do
    subject(:config) { described_class.new }

    describe '#auth_token' do
      it 'should default to KONEKT_WEBHOOK_KEY' do
        ENV['KONEKT_WEBHOOK_KEY'] = 'test-key'
        expect(config.auth_token).to eq 'test-key'
      end
    end
  end
end
