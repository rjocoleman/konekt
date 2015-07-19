module Konekt

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor *[
      :logger,
      :mount_point,
      :auth_token,
      :raise_exceptions,
    ]

    alias_method :raise_exceptions?, :raise_exceptions

    def initialize
      @mount_point      = '/konekt_processor'
      @logger           = Logger.new STDOUT
      @auth_token       = ENV['KONEKT_WEBHOOK_KEY']
      @raise_exceptions = true unless ENV['RACK_ENV'] == 'production'
    end

  end
end
