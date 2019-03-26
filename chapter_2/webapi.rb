# webapi.rb
require 'sinatra'
require 'json'
require 'gyoku'
require 'pry'

# non-persisted users
users = {
    'jimmy': { first_name: 'Jimmy', last_name: 'N', email: 'jimmy@g.com', age: 26},
    'simon': { first_name: 'Simon', last_name: 'O', email: 'simon@h.com', age: 29},
    'ruth': { first_name: 'Ruth', last_name: 'W', email: 'ruth@h.com', age: 29}

}

helpers do

  def json_or_default?(type)
        %w(application/json application/* */*).include?(type.to_s)
  end

  def xml?(type)
    type.to_s == "application/xml"
  end

  def accepted_media_type
    return "json" unless request.accept.any?

    request.accept.each do |mt|
      return "json" if json_or_default?(mt)
      return "xml" if xml?(mt)
    end

    halt 406, 'Not Acceptable'
  end

  def type
    @type ||= accepted_media_type
  end

  def send_data(data = {})
    if type == 'json'
      content_type 'application/json'
      data[:json].call.to_json if data[:json]
    elsif  type == 'xml'
      content_type 'application/xml'
      Gyoku.xml(data[:xml].call) if data[:xml]
    end
  end
end

get '/' do
  'Master Ruby Web APIs - Chapter 2'
end

# Resource to get all users
get '/users' do
  send_data(json: -> { users.map {|name, data| data.merge(id: name) } },
            xml: -> { { users: users} } )
end

# HEAD request: similar to GET but does not return a body
head '/users' do
  send_data
end

# Resource to create users (book location url is wrong, change to downcase)
post '/users' do
  user = JSON.parse(request.body.read)
  users[user['first_name'].downcase.to_sym] = user

  url = "http://localhost:4567/users/#{user['first_name'].downcase}"
  response.headers['Location'] = url

  status 201
end

# Resource to get individual users
get '/users/:first_name' do |first_name|
  send_data(json: -> { users[first_name.to_sym].merge(id: first_name) },
            xml: -> { { first_name => users[first_name.to_sym] } })
end

# Resource to edit a user
put '/users/:first_name' do |first_name|
  user = JSON.parse(request.body.read)
  existing = users[first_name.to_sym]
  users[first_name.to_sym] = user
  status existing ? 204 : 201
end

# Resource to update specific parameters in a resource
patch '/users/:first_name' do |first_name|
  user_client = JSON.parse(request.body.read)
  user_server = users[first_name.to_sym]

  user_client.each do |key, value|
    user_server[key.to_sym] = value
  end

    send_data(json: -> { user_server.merge(id: first_name) },
              xml: -> { { first_name => user_server} })
end

delete '/users/:first_name' do |first_name|
  users.delete(first_name.to_sym)
  status 204
end

options '/users' do
  response.header['Allow'] = 'HEAD, GET, POST'
  status 200
end

options '/users/:first_name' do
  response.headers['Allow'] = 'GET', 'PUT', 'PATCH', 'DELETE'
  status 200
end