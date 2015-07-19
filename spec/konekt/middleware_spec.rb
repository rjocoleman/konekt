require 'rack/test'
require 'konekt/middleware'

module Konekt
  RSpec.describe Middleware do
    include ::Rack::Test::Methods

    before do
      Konekt.configure do |config|
        config.mount_point = '/test_processor'
        config.auth_token  = 'token'
        config.logger
      end
      Konekt::LISTENERS.clear
    end

    let(:konekt_config) { Konekt.configuration }
    let(:stack) { double }
    let(:app) { Konekt::Middleware.new stack }
    let(:endpoint) { '/test_processor?key=token' }

    it 'propgates an event' do
      receiver = double
      expect(receiver).to receive :passed

      Konekt.subscribe 'test_event' do |event|
        receiver.passed
        expect(event.tags).to include 'test_event'
        expect(event.received_at).to eq Time.gm 1990
        expect(event.data).to eq 'Hello!!'
      end

      post_event 'test_event'

      expect(last_response).to be_ok
      expect(last_response.body).to eq('ACK')
    end

    it 'handles an invalid POST' do
      log = StringIO.new
      konekt_config.logger = Logger.new log
      post endpoint, payload: '{'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('Ignored invalid event')
      expect(log.string).to match /A JSON text must at least contain two octets/
    end

    it 'forbids unauthenticated access' do
      post '/test_processor', '{}'
      expect(last_response.status).to eq(403)
    end

    it 'responds with 405 for GET' do
      get endpoint
      expect(last_response.status).to eq 405
    end

    it 'passes through unmatched requests' do
      expect(stack).to receive_request '/other/path'
      get '/other/path'
    end

    context 'when a listener raises an exception' do |variable|
      before { listen_with_exception 'test_event', 'test exception' }

      it 'should raise when configured to raise exceptions' do
        konekt_config.raise_exceptions = true
        expect { post_event 'test_event' }.to raise_error 'test exception'
      end

      it 'should respond with 500 when configured not to raise exceptions' do
        konekt_config.raise_exceptions = false
        post_event 'test_event'
        expect(last_response.status).to eq 500
        expect(last_response.body).to eq 'NAK'
      end
    end

    def receive_request(path)
      env = hash_including 'PATH_INFO' => path
      receive(:call).with(env).and_return([200, {}, 'OK'])
    end

    def listen_with_exception(tag, message)
      Konekt.subscribe tag do |event|
        raise message
      end
    end

    def post_event(tag)
      data = {
        payload: '{"received": "1990-01-01 00:00:00 UTC", "authtype": "psk", "tags": ["' + tag + '"], "device_name": "Unnamed Device", "errorcode": 0, "source": "sss", "data": "SGVsbG8hIQ==", "device_id": 100}',
        properties: '{"url": "http://example.com", "user_id": 123}',
        userid: 123,
      }
      post endpoint, data
    end
  end
end
