require 'sinatra'
require 'sinatra/contrib'
require 'json'

users = {
    jimmy: { first_name: 'Jimmy', last_name: 'Hendrix', age:25, email: 'jimmhex@kuku.com' }
}

before do
  content_type  'application/json'
end

namespace '/v1' do
  get '/users' do
    users.map { |name, data| data.merge(id: name) }.to_json
  end
end

namespace '/v2' do
  get '/users' do
    users.map do |name, data|
      {
          full_name: "#{data[:first_name]} #{data[:last_name]}",
          age: data[:age]
      }
    end.to_json
  end
end