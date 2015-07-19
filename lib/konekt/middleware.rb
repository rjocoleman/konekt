require 'konekt/configuration'
require 'konekt/event'
require 'konekt/listeners'

module Konekt
  class Middleware

    def initialize(app=nil)
      @app = app
    end

    def config
      Konekt.configuration
    end

    def call(env)
      req = Rack::Request.new(env)
      return @app.call(env) unless req.path_info == config.mount_point
      return response 405 unless req.post?
      return response 403 unless req.params['key'] == config.auth_token

      parse_and_respond req.params
    end

  private

    def parse_and_respond(params)
      event = Event.from_params params
      Konekt.propagate event
      response 200, 'ACK'
    rescue Event::InvalidEventData => e
      config.logger.error e
      response 200, 'Ignored invalid event'
    rescue => e
      raise e if config.raise_exceptions?
      response 500, 'NAK'
    end

    def response(status, body='', headers={})
      [
        status,
        {'Content-Type' => 'text/plain'}.merge(headers),
        [body],
      ]
    end

  end
end
