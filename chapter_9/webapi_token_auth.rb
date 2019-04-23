require 'sinatra'
require 'json'
require 'pry'

# User database
users = { 'ruthnwaiganjo@gmail.com' => 'supersecret'}

# Tokens stored in a hash
tokens = {}

helpers do
  def unauthorized!
    response.headers['www-Authenticate'] = ' Token realm="Token Realm"'
    halt 401
  end

  def authenticate!(tokens)
    auth = env['HTTP_AUTHORIZATION']
    # Check if authorization header was provided
    #  Check if it matches the format we want: Token ksdjbdjbjdb
    unauthorized! unless auth && auth.match(/Token .+/)
    _, access_token = auth.split(' ')
    # Check in the tokens hash if there is a token with the value sent by the client
    unauthorized! unless tokens[access_token]
  end
end

get '/' do
  authenticate!(tokens)
  'Master Ruby Web APIs - Chapter 9'
end

post '/login' do
  params = JSON.parse(request.body.read)
  email = params['email']
  password = params['password']
  content_type 'application/json'
  # If email and password are correct
  if users[email] && users[email] == params['password']
    # Generate a token
    token = SecureRandom.hex
    # Store it in the tokens hash with a way
    # to get the user from that token
    tokens[token] = email
    { 'access_token' => token }.to_json
  else
    # If not, a generic error message is sent back
    # To prevent attackers from knowing when they got an email or password correctly
    halt 400, { error: 'Invalid username or password' }.to_json
  end
end

delete '/logout' do
  access_token = authenticate!(tokens)
  tokens.delete(access_token)
  halt 204
end

