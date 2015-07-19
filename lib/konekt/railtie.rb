require 'konekt/middleware'

module Konekt
  class Railtie < Rails::Railtie

    initializer 'konekt.use_rack_middleware' do |app|
      app.config.middleware.use 'Konekt::Middleware'
    end

  end
end
