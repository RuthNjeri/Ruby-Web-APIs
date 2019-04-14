require 'sinatra'
require 'json'
require 'pry'
# require 'digest/sha1'

users = {
    revision: 1,
    list: {
        thibault: { first_name: 'Jimmy', last_name: 'Denis', age: 80 },
        ruth: { first_name: 'Ruth', last_name: 'Denis', age: 80 },
        denisi: { first_name: 'Denisi', last_name: 'Denis', age: 60 }
    }
}

cached_data = {}

helpers do
    def cache_and_return(cached_data, key, &block)
      cached_data[key] ||= block.call
      cached_data[key]
    end
end

before do
  content_type 'application/json'
end

get '/users' do
  key = "users: #{users[:revision]}"
  cache_and_return(cached_data, key) do
    (1..1000).each_with_object([]) do |i, array|
      users[:list].each do |name, data|
        array << data
      end
    end.to_json
  end
end

put '/users/:first_name' do |first_name|
  user = JSON.parse(request.body.read)
  existing = users[:list][first_name.to_sym]
  users[:list][first_name.to_sym] = user
  users[:revision] += 1
  status existing ? 204 : 201
end




