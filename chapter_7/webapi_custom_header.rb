require 'sinatra'
require 'json'

users = {
    jimmy: { first_name: 'jimmy', last_name: 'K', age: 26 },
    ruth: { first_name: 'ruth', last_name: 'W', age: 24 },
    john: { first_name: 'john', last_name: 'W', age: 28 },
}

helpers do
  def present_v2(data)
    {
        full_name: "#{data[:first_name]} #{data[:last_name]}",
        age: data[:age]
    }
  end
end

before do
  content_type 'application/json'
end

get '/users' do
  if request.env['HTTP_VERSION'] == '2.0'
    halt 200, users.map { |name, data| present_v2(data) }.to_json
  end
  users.map { |name, data| data }.to_json
end