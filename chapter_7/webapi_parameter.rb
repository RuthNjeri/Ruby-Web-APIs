require 'sinatra'
require 'sinatra/contrib'
require 'json'

users = {
    jimmy: { first_name: 'Jimmy', last_name: 'Hendrix', age:'26'},
    simon: { first_name: 'Simon', last_name: 'Sinek', age: '40' },
    john: { first_name: 'John', last_name: 'Doe', age: '30' }
}

before do
  content_type 'application/json'
end

helpers do
  def present_300
    {
        message: 'Multiple Versions Available (?version=)',
        links: {
            v1: '/users?version=v1',
            v2: '/users?version=v2'
        }
    }
  end

  def present_data(data)
    {
        full_name: "#{data[:first_name]} #{data[:last_name]}",
        age: data[:age]
    }
  end
end

get '/users' do
  versions = {
      'v1' => lambda { |name, data| data },
      'v2' => lambda { |name, data| present_v2(data) }
  }

  unless params['version'] && versions.keys.include?(params['version'])
    halt 300, present_300.to_json
  end

  users.map(&versions[params['version']]).to_json
end