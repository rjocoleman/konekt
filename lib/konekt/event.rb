require 'json'
require 'base64'

module Konekt
  class Event
    class InvalidEventData < StandardError; end

    attr_reader *[
      :tags,
      :data,
      :received_at,
      :source,
      :device_name,
      :user_id,
      :payload,
      :properties
    ]

    def self.from_params(params)
      attrs       = JSON.parse params['payload']
      tags        = attrs.fetch('tags')
      data        = Base64.decode64(attrs.fetch('data'))
      received_at = Time.parse(attrs.fetch('received'))
      source      = attrs.fetch('source')
      device_name = attrs.fetch('device_name')
      user_id     = params['userid']
      properties  = JSON.parse params['properties']

      event = { tags: tags,
        data: data,
        received_at: received_at,
        source: source,
        device_name: device_name,
        user_id: user_id,
        payload: attrs,
        properties: properties,
      }
      new event

    rescue ArgumentError, KeyError, JSON::JSONError => e
      raise InvalidEventData, e
    end

    def initialize(opts={})
      @tags = opts[:tags]
      @data = opts[:data]
      @received_at = opts[:received_at] || Time.now.utc
      @source = opts[:source]
      @device_name = opts[:device_name]
      @user_id = opts[:user_id]
      @payload = opts[:payload]
      @properties = opts[:properties]
    end

  end
end
