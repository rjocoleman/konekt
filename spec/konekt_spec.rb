require 'konekt'

describe Konekt do
  it 'has a version number' do
    expect(Konekt::VERSION).not_to be nil
  end

  it 'can be configured' do
    Konekt.configure do |config|
      config.mount_point = 'test_mount'
    end
    expect(Konekt.configuration.mount_point).to eq 'test_mount'
  end
end
