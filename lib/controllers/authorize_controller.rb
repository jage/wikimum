require 'uri'

class AuthorizeController < BaseController
  get '/' do
    parameters = %Q(?scope=user:email&client_id=#{ENV.fetch('GITHUB_BASIC_CLIENT_ID')})

    redirect URI.join(Authorize::GITHUB_OAUTH_AUTHORIZE_URL, parameters)
  end

  get '/callback' do
    session_code = request.env.fetch('rack.request.query_hash').fetch('code')
    access_token = Authorize.access_token(session_code)
    user_info    = Authorize.user_info(access_token)

    user_info.each do |key, value|
      session[key] = value
    end

    redirect '/'
  end

  get '/reset' do
    session.clear

    redirect back
  end
end
