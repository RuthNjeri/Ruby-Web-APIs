require 'sinatra'
require 'json'
require 'sinatra/subdomain'

# non-persisted users
users = {
    'jimmy': { first_name: 'Jimmy', last_name: 'N', email: 'jimmy@g.com', age: 26},
    'simon': { first_name: 'Simon', last_name: 'O', email: 'simon@h.com', age: 29},
    'ruth': { first_name: 'Ruth', last_name: 'W', email: 'ruth@h.com', age: 29}
}

before do
  content_type 'application/json'
end

#routes for V1
subdomain :api do

  get '/users' do
    users.map { |name, data| data }
  end
end

subdomain :api2 do

  get '/users' do
    users.map do |name, data|
      {
          full_name: "#{data[:first_name]} #{data[:last_name]}",
          age: data[:age]
      }
    end.to_json
  end
end
