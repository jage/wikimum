require_relative 'config/sentry'

require 'rack/ssl'

use Raven::Rack

def development?
  ENV.fetch('RACK_ENV') == 'development'
end

require_relative 'config/environment'

unless development?
  use Rack::SSL
end

use Rack::Session::Cookie,
  secret: ENV.fetch('SESSION_SECRET'),
  expire_after: 60 * 60 * 24 * 365

use Rack::Static, {
  root: "public",
  urls: ["/stylesheets", "/images", "/javascripts", "/favicon.ico", "/robots.txt"],
  cache_control: "public,max-age=#{365 * 24 * 3600}"
}

map '/' do
  run PageController
end

map '/authorize' do
  run AuthorizeController
end

map '/user' do
  run UserController
end
