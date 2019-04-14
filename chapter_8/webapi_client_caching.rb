require 'sinatra'
require 'json'
require 'digest/sha1'

users = {
    jimmy: { first_name: 'Jimmy', last_name: 'Hendrix', age: 26},
    simon: { first_name: 'Simon', last_name: 'Hexx', age: 27},
    john: { first_name: 'John', last_name: 'Kash', age: 28}
}

before do
  content_type 'application/json'
  cache_control max_age: 60
end

get '/users' do
  etag Digest::SHA1.hexdigest(users.to_s)
  users.map { |name, data| data }.to_json
end