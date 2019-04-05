require 'sinatra'
require 'json'

users = {
    jimmy: { first_name: 'jimmy', last_name: 'K', age: 26 },
    ruth: { first_name: 'ruth', last_name: 'W', age: 24 },
    john: { first_name: 'john', last_name: 'W', age: 28 },
}

helpers do
  def present_user(data)
    {
        full_name: "#{data[:first_name]} #{data[:last_name]}",
        age: data[:age],
        first_name: data[:first_name],
        last_name: data[:last_name]
    }
  end
end

get '/users' do
  media_type = request.accept.first.to_s
  unless [ '*/*', 'application/*', 'application/json'].include?(media_type)
    halt 406
  end

  content_type 'application/json'
  users.map { |name, data| present_user(data) }.to_json
end
